<#
WellWish developer commands. Run from the project root in PowerShell:

    .\ww.ps1 <command> [args]

Backend runs in Docker (infra/docker-compose.yml). Flutter apps and the admin panel run on Windows.
Docker Desktop must be running.
#>
param(
    [Parameter(Position = 0)][string]$Command = "help",
    [Parameter(Position = 1, ValueFromRemainingArguments = $true)][string[]]$Rest
)

# Native tools (docker, npm, melos) report failure through exit codes, which we check ourselves.
# "Stop" would turn their normal stderr output into PowerShell errors on Windows PowerShell 5.1.
$ErrorActionPreference = "Continue"
$Root = $PSScriptRoot
$Compose = @("compose", "-f", (Join-Path $Root "infra\docker-compose.yml"))
$AdminDir = Join-Path $Root "apps\admin_web"
$StateDir = Join-Path $Root ".ww"
$OpenApiGenImage = "openapitools/openapi-generator-cli:v7.26.0"

function Say([string]$msg) { Write-Host "==> $msg" -ForegroundColor Cyan }
function Fail([string]$msg) { Write-Host "ERROR: $msg" -ForegroundColor Red; exit 1 }

function Invoke-Native {
    # Runs a tool, shows its output on screen, and returns ONLY its exit code.
    param([string]$Exe, [string[]]$Arguments)
    & $Exe @Arguments 2>&1 | ForEach-Object { Write-Host $_ }
    return $LASTEXITCODE
}

function Ensure-Docker {
    docker info *> $null
    if ($LASTEXITCODE -ne 0) { Fail "Docker Desktop is not running. Start it and wait for 'Engine running'." }
}

function Ensure-Env {
    $envFile = Join-Path $Root "backend\.env"
    if (-not (Test-Path $envFile)) {
        Copy-Item (Join-Path $Root "backend\.env.example") $envFile
        Say "Created backend\.env from backend\.env.example"
    }
}

function Test-ApiRunning {
    $state = docker @Compose ps --status running --services 2>$null
    return ($state -contains "api")
}

function Ensure-Backend {
    Ensure-Docker
    Ensure-Env
    if (-not (Test-ApiRunning)) {
        Say "Starting backend containers"
        $code = Invoke-Native "docker" ($Compose + @("up", "-d", "--build", "--wait"))
        if ($code -ne 0) { Fail "Backend containers did not become healthy. Run .\ww.ps1 logs" }
    }
}

function Invoke-Api {
    param([string[]]$Arguments)
    return Invoke-Native "docker" ($Compose + @("exec", "-T", "api") + $Arguments)
}

function Test-Port([int]$Port) {
    $conn = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
    return [bool]$conn
}

function Start-Admin {
    if (-not (Test-Path (Join-Path $AdminDir "package.json"))) { return }
    if (Test-Port 3000) { Say "Admin panel already running on http://localhost:3000"; return }
    if (-not (Test-Path (Join-Path $AdminDir "node_modules"))) {
        Say "Installing admin panel packages"
        Push-Location $AdminDir; npm install; Pop-Location
    }
    New-Item -ItemType Directory -Force $StateDir | Out-Null
    $proc = Start-Process powershell -PassThru -WorkingDirectory $AdminDir `
        -ArgumentList "-NoExit", "-Command", "`$host.UI.RawUI.WindowTitle='WellWish admin (npm run dev)'; npm run dev"
    Set-Content -Path (Join-Path $StateDir "admin.pid") -Value $proc.Id
    Say "Admin panel starting in a new window: http://localhost:3000"
}

function Stop-Admin {
    $pidFile = Join-Path $StateDir "admin.pid"
    if (Test-Path $pidFile) {
        $adminPid = Get-Content $pidFile
        # stop the window and everything it started (node, next dev server)
        taskkill /PID $adminPid /T /F *> $null
        Remove-Item $pidFile -Force
        Say "Admin panel stopped"
    }
}

function Invoke-BackendChecks {
    $results = [ordered]@{}
    $results["backend: ruff"] = Invoke-Api @("ruff", "check", ".")
    $results["backend: format"] = Invoke-Api @("ruff", "format", "--check", ".")
    $results["backend: mypy"] = Invoke-Api @("mypy", ".")
    $results["backend: pytest"] = Invoke-Api @("pytest")
    $results["backend: migrations"] = Invoke-Api @("python", "manage.py", "makemigrations", "--check", "--dry-run")
    return $results
}

function Invoke-FlutterChecks {
    $results = [ordered]@{}
    if (-not (Test-Path (Join-Path $Root "pubspec.yaml"))) { return $results }
    Push-Location $Root
    try {
        # melos is installed with `dart pub global activate melos`; calling it through dart
        # works even when the pub cache bin folder is not on PATH.
        $results["flutter: pub get"] = Invoke-Native "flutter" @("pub", "get")
        # --no-select: run in every package without asking which one (melos would wait for input)
        $results["flutter: analyze"] = Invoke-Native "dart" @("pub", "global", "run", "melos", "run", "analyze", "--no-select")
        # Phase 9.1: every word on screen comes from the translations (English, Hindi, Odia)
        $results["flutter: no hard-coded text"] = Invoke-Native "dart" @("tool/check_texts.dart")
        $results["flutter: test"] = Invoke-Native "dart" @("pub", "global", "run", "melos", "run", "test", "--no-select")
    } finally { Pop-Location }
    return $results
}

function Invoke-AdminChecks {
    $results = [ordered]@{}
    if (-not (Test-Path (Join-Path $AdminDir "package.json"))) { return $results }
    Push-Location $AdminDir
    try {
        if (-not (Test-Path "node_modules")) { npm install | Out-Host }
        $results["admin: lint"] = Invoke-Native "npm" @("run", "lint")
        $results["admin: build"] = Invoke-Native "npm" @("run", "build")
    } finally { Pop-Location }
    return $results
}

function Show-Summary($results) {
    Write-Host ""
    Write-Host "Check summary" -ForegroundColor Cyan
    $failed = 0
    foreach ($name in $results.Keys) {
        if ($results[$name] -eq 0) {
            Write-Host ("  PASS  " + $name) -ForegroundColor Green
        } else {
            Write-Host ("  FAIL  " + $name) -ForegroundColor Red
            $failed++
        }
    }
    if ($failed -gt 0) { Write-Host "$failed check(s) failed." -ForegroundColor Red; exit 1 }
    Write-Host "All checks passed." -ForegroundColor Green
}

switch ($Command) {
    "up" {
        Ensure-Docker; Ensure-Env
        Say "Starting backend containers (db, redis, api, worker, beat)"
        $code = Invoke-Native "docker" ($Compose + @("up", "-d", "--build", "--wait"))
        if ($code -ne 0) { Fail "Containers did not become healthy. Run .\ww.ps1 logs" }
        docker @Compose ps
        Start-Admin
        Say "API: http://localhost:8000/v1/health   Docs: http://localhost:8000/v1/docs"
    }
    "down" {
        Stop-Admin
        Ensure-Docker
        docker @Compose down
    }
    "restart" {
        Ensure-Docker
        docker @Compose restart @Rest
    }
    "ps" { Ensure-Docker; docker @Compose ps }
    "logs" { Ensure-Docker; docker @Compose logs -f --tail 200 @Rest }
    "shell" { Ensure-Backend; docker @Compose exec api python manage.py shell }
    "manage" { Ensure-Backend; exit (Invoke-Api (@("python", "manage.py") + $Rest)) }
    "migrate" { Ensure-Backend; exit (Invoke-Api @("python", "manage.py", "migrate")) }
    "makemigrations" { Ensure-Backend; exit (Invoke-Api (@("python", "manage.py", "makemigrations") + $Rest)) }
    "seed" { Ensure-Backend; exit (Invoke-Api (@("python", "manage.py", "seed") + $Rest)) }
    "test" { Ensure-Backend; exit (Invoke-Api (@("pytest") + $Rest)) }
    "lint" {
        Ensure-Backend
        $r = [ordered]@{}
        $r["backend: ruff"] = Invoke-Api @("ruff", "check", ".")
        $r["backend: format"] = Invoke-Api @("ruff", "format", "--check", ".")
        $r["backend: mypy"] = Invoke-Api @("mypy", ".")
        Show-Summary $r
    }
    "format" { Ensure-Backend; Invoke-Api @("ruff", "format", ".") | Out-Null; Invoke-Api @("ruff", "check", "--fix", ".") | Out-Null }
    "openapi" {
        Ensure-Backend
        $code = Invoke-Api @("python", "manage.py", "export_openapi_schema", "--api", "config.api.api",
            "--output", "/docs/api/openapi.json", "--indent", "2")
        if ($code -ne 0) { Fail "OpenAPI export failed" }
        Say "Wrote docs\api\openapi.json"
    }
    "gen-clients" {
        Ensure-Docker
        $spec = Join-Path $Root "docs\api\openapi.json"
        if (-not (Test-Path $spec)) { Fail "docs\api\openapi.json is missing. Run .\ww.ps1 openapi first." }

        Say "Dart client -> packages\ww_api"
        # Everything in these folders is generated: clear them so models removed from the API
        # don't linger (the generator never deletes old files).
        foreach ($dir in @("lib", "doc", "test")) {
            $old = Join-Path $Root "packages\ww_api\$dir"
            if (Test-Path $old) { Remove-Item -Recurse -Force $old }
        }
        $code = Invoke-Native "docker" @("run", "--rm", "-v", "${Root}:/local", $OpenApiGenImage, "generate",
            "-i", "/local/docs/api/openapi.json", "-g", "dart-dio", "-o", "/local/packages/ww_api",
            "--additional-properties=pubName=ww_api,pubDescription=WellWish API client (generated),serializationLibrary=json_serializable",
            "--skip-validate-spec")
        if ($code -ne 0) { Fail "Dart client generation failed" }
        Push-Location (Join-Path $Root "packages\ww_api")
        try {
            # The generator writes sdk '>=3.5.0', but json_serializable's output needs Dart 3.8+
            # (null-aware map elements). Raise the floor so the generated code compiles.
            $pubspec = Join-Path (Get-Location) "pubspec.yaml"
            $text = [IO.File]::ReadAllText($pubspec) -replace "sdk: '>=3\.\d+\.\d+ <4\.0\.0'", "sdk: '>=3.8.0 <4.0.0'"
            [IO.File]::WriteAllText($pubspec, $text, (New-Object Text.UTF8Encoding $false))
            dart pub get | Out-Host
            dart run build_runner build --delete-conflicting-outputs | Out-Host
            if ($LASTEXITCODE -ne 0) { Fail "build_runner failed for ww_api" }
            # Some schema shapes (enum or list defaults, number-or-text unions) generate Dart that
            # doesn't compile. Catch that here instead of in the apps' tests.
            dart analyze --no-fatal-warnings lib | Out-Host
            if ($LASTEXITCODE -ne 0) { Fail "The generated ww_api code has errors. Check the schema shapes." }
        } finally { Pop-Location }

        if (Test-Path (Join-Path $AdminDir "package.json")) {
            Say "TypeScript types -> apps\admin_web\src\api\schema.d.ts"
            Push-Location $AdminDir
            try {
                npx openapi-typescript ..\..\docs\api\openapi.json -o src\api\schema.d.ts
                if ($LASTEXITCODE -ne 0) { Fail "TypeScript generation failed" }
            } finally { Pop-Location }
        }
        Say "Clients regenerated"
    }
    "check" {
        Ensure-Backend
        $all = [ordered]@{}
        (Invoke-BackendChecks).GetEnumerator() | ForEach-Object { $all[$_.Key] = $_.Value }
        (Invoke-FlutterChecks).GetEnumerator() | ForEach-Object { $all[$_.Key] = $_.Value }
        (Invoke-AdminChecks).GetEnumerator() | ForEach-Object { $all[$_.Key] = $_.Value }
        Show-Summary $all
    }
    "build" {
        # Phase 9.3 (ARCHITECTURE 12, Mobile): store builds are obfuscated. The symbols that turn an obfuscated
        # crash report back into names stay on this PC (build\symbols\<app>\<flavor>\<version>),
        # never in the app: keep them with the release.
        $usage = "Usage: .\ww.ps1 build patient|partner [prod|staging|dev] [apk|appbundle]"
        $app = if ($Rest.Count -ge 1) { $Rest[0] } else { "" }
        $flavor = if ($Rest.Count -ge 2) { $Rest[1] } else { "prod" }
        $format = if ($Rest.Count -ge 3) { $Rest[2] } else { "apk" }
        if ($app -notin @("patient", "partner")) { Fail $usage }
        if ($flavor -notin @("prod", "staging", "dev")) { Fail $usage }
        if ($format -notin @("apk", "appbundle")) { Fail $usage }
        $appDir = Join-Path $Root "apps\${app}_app"
        $version = ((Select-String -Path (Join-Path $appDir "pubspec.yaml") -Pattern "^version:\s*(\S+)").Matches[0].Groups[1].Value) -replace "\+", "-"
        $symbols = Join-Path $Root "build\symbols\$app\$flavor\$version"
        if (-not (Test-Path (Join-Path $appDir "android\key.properties"))) {
            Write-Host "Note: apps\${app}_app\android\key.properties not found, so this build is signed with the debug key (fine on a test phone, refused by the Play Store). See docs\KEYS-AND-ACCOUNTS.md" -ForegroundColor Yellow
        }
        $buildArgs = @("build", $format, "--release", "--flavor", $flavor, "-t", "lib/main_$flavor.dart",
            "--obfuscate", "--split-debug-info=$symbols")
        # error reports (PHASES 9.5): the app's Sentry DSN, when set on this PC (off otherwise)
        $dsn = [Environment]::GetEnvironmentVariable("SENTRY_DSN_" + $app.ToUpper())
        if ($dsn) { $buildArgs += "--dart-define=SENTRY_DSN=$dsn"; Say "Sentry on for this build" }
        Push-Location $appDir
        try {
            $code = Invoke-Native "flutter" $buildArgs
        } finally { Pop-Location }
        if ($code -ne 0) { Fail "The build failed" }
        Say "Built (obfuscated): apps\${app}_app\build\app\outputs"
        Say "Crash-report symbols: $symbols (keep them with this release; never ship them)"
        # the release build used a lot of memory (the dev PC is tight on RAM). gradlew needs a Java:
        # the one Flutter uses (Android Studio's) when JAVA_HOME isn't set.
        $studioJava = "C:\Program Files\Android\Android Studio\jbr"
        if (-not $env:JAVA_HOME -and (Test-Path $studioJava)) { $env:JAVA_HOME = $studioJava }
        Push-Location (Join-Path $appDir "android"); .\gradlew --stop *> $null; Pop-Location
        exit 0
    }
    "loadtest" {
        # Phase 9.4 (ARCHITECTURE 13): 100 partners sending their location every 10 s and 30
        # bookings a minute, against the API run as on a server, on its own database
        # (wellwish_loadtest, made fresh each time). Target: p95 < 300 ms, nothing failing.
        # .\ww.ps1 loadtest [minutes] [API worker processes]
        Ensure-Backend
        $minutes = if ($Rest.Count -ge 1) { [int]$Rest[0] } else { 5 }
        $env:LOADTEST_API_WORKERS = if ($Rest.Count -ge 2) { $Rest[1] } else { "1" }
        $Load = $Compose + @("--profile", "loadtest")
        # the Locust image first: the people's tokens are made just before the run
        $code = Invoke-Native "docker" ($Load + @("build", "locust"))
        if ($code -ne 0) { Fail "Could not build the Locust image" }
        Say "A fresh load-test database (your dev data is not touched)"
        docker @Load stop api-load worker-load *> $null
        docker @Compose exec -T db dropdb -U wellwish --if-exists --force wellwish_loadtest *> $null
        docker @Compose exec -T db createdb -U wellwish wellwish_loadtest
        if ($LASTEXITCODE -ne 0) { Fail "Could not create the load-test database" }
        docker @Compose exec -T redis sh -c "for n in 8 9 10 11; do redis-cli -n `$n flushdb > /dev/null; done"
        Say "Starting the API as on a server ($env:LOADTEST_API_WORKERS worker process(es)) and a Celery worker"
        $code = Invoke-Native "docker" ($Load + @("up", "-d", "--build", "--force-recreate", "--wait", "api-load", "worker-load"))
        if ($code -ne 0) { Fail "The load-test API did not start. See: docker compose -f infra\docker-compose.yml --profile loadtest logs api-load" }
        Say "Creating 100 partners on live jobs and 100 patients who book"
        $code = Invoke-Native "docker" ($Load + @("exec", "-T", "api-load", "python", "manage.py", "loadtest_data"))
        if ($code -ne 0) { docker @Load stop api-load worker-load | Out-Null; Fail "loadtest_data failed" }
        Say "Running Locust for $minutes minute(s)"
        New-Item -ItemType Directory -Force (Join-Path $Root "infra\loadtest\results") | Out-Null
        # run without its dependencies (built above): "run" would otherwise restart the API
        $code = Invoke-Native "docker" ($Load + @("run", "--rm", "--no-deps", "locust", "-f", "/mnt/locust/locustfile.py",
            "--headless", "--host", "http://api-load:8000", "-u", "103", "-r", "20", "-t", "${minutes}m", "--only-summary",
            "--csv", "/mnt/locust/results/run", "--html", "/mnt/locust/results/report.html"))
        Say "Stopping the load-test containers"
        docker @Load stop api-load worker-load *> $null
        if ($code -ne 0) { Fail "The load test missed the target or had failures. Report: infra\loadtest\results\report.html" }
        Say "Target met. Report: infra\loadtest\results\report.html"
    }
    "s3-test" {
        # Phase 9B.5 (ARCHITECTURE 6.8): uploads are a presigned POST whose policy limits the
        # size and type. Proved against a real S3 API (SeaweedFS's S3 gateway, a throwaway store
        # in Docker) before AWS exists: the store refuses a file over the limit, another type or
        # another key.
        Ensure-Backend
        $S3 = $Compose + @("--profile", "s3test")
        Say "Starting the S3 test store"
        $code = Invoke-Native "docker" ($S3 + @("up", "-d", "s3test"))
        if ($code -ne 0) { Fail "Could not start the S3 test store" }
        $code = Invoke-Native "docker" ($Compose + @("exec", "-T",
            "-e", "S3_TEST_ENDPOINT=http://s3test:8333",
            "-e", "AWS_ACCESS_KEY_ID=wellwish-s3-test",
            "-e", "AWS_SECRET_ACCESS_KEY=wellwish-s3-test-only",
            "api", "pytest", "-q", "-rs", "-p", "no:cacheprovider", "apps/files/tests/test_s3_storage.py"))
        Say "Removing the S3 test store"
        docker @S3 rm -sf s3test *> $null
        if ($code -ne 0) { Fail "The S3 upload test failed" }
        Say "S3 test passed: the storage itself refuses a bigger file, another type or another key"
    }
    "backup" {
        # Phase 9.6 (ARCHITECTURE 12, Backups): a copy of the local database (pg_dump, custom
        # format) and the uploads, in backups\ (git-ignored), with the row count of every table.
        # Servers use RDS backups instead (docs\runbooks\backups.md).
        Ensure-Docker
        $dir = Join-Path $Root "backups"
        New-Item -ItemType Directory -Force $dir | Out-Null
        $name = "wellwish-" + (Get-Date -Format "yyyyMMdd-HHmmss")
        $countSql = Get-Content (Join-Path $Root "infra\postgres\row_counts.sql") -Raw
        Say "Copying the database"
        # the row counts must match the copy: counted before and after it; a change meanwhile
        # (a background job) means another try
        for ($try = 1; $try -le 3; $try++) {
            $before = @($countSql | docker @Compose exec -T db psql -U wellwish -d wellwish -At -F " ")
            docker @Compose exec -T db pg_dump -U wellwish -d wellwish -Fc -f "/tmp/$name.dump"
            if ($LASTEXITCODE -ne 0) { Fail "pg_dump failed" }
            $counts = @($countSql | docker @Compose exec -T db psql -U wellwish -d wellwish -At -F " ")
            # (Compare-Object fails on an empty list: the row counts must exist to mean anything)
            if ($before.Count -eq 0 -or $counts.Count -eq 0) { Fail "Could not count the rows of the tables" }
            if (-not (Compare-Object $before $counts)) { break }
            if ($try -eq 3) { Fail "The database kept changing during the copy; try again" }
        }
        docker @Compose cp "db:/tmp/$name.dump" (Join-Path $dir "$name.dump") *> $null
        if ($LASTEXITCODE -ne 0) { Fail "Could not copy the backup out of the container" }
        docker @Compose exec -T db rm -f "/tmp/$name.dump" *> $null
        $counts | Set-Content -Encoding ascii (Join-Path $dir "$name.counts.txt")
        $media = Join-Path $Root "backend\media"
        if (Test-Path $media) {
            Say "Copying the uploads (backend\media)"
            Compress-Archive -Path (Join-Path $media "*") -DestinationPath (Join-Path $dir "$name-media.zip") -Force
        }
        $size = [math]::Round((Get-Item (Join-Path $dir "$name.dump")).Length / 1MB, 1)
        Say "Backup: backups\$name.dump ($size MB, $(@($counts).Count) tables) + .counts.txt + -media.zip"
        Say "Check it with: .\ww.ps1 restore-test backups\$name.dump"
    }
    "restore-test" {
        # Phase 9.6: restores a backup into a separate database (wellwish_restore) and checks it:
        # every table has the rows it had when backed up, and the app finds every migration
        # applied. Your dev database is not touched. .\ww.ps1 restore-test [file] (default: newest)
        Ensure-Backend
        $dir = Join-Path $Root "backups"
        $file = if ($Rest.Count -ge 1) { Get-Item $Rest[0] } else {
            Get-ChildItem $dir -Filter "*.dump" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime | Select-Object -Last 1
        }
        if (-not $file) { Fail "No backup found. Make one with: .\ww.ps1 backup" }
        $countsFile = $file.FullName -replace "\.dump$", ".counts.txt"
        if (-not (Test-Path $countsFile)) { Fail "$countsFile is missing (made by .\ww.ps1 backup)" }
        Say "Restoring $($file.Name) into wellwish_restore"
        docker @Compose exec -T db dropdb -U wellwish --if-exists --force wellwish_restore *> $null
        docker @Compose exec -T db createdb -U wellwish wellwish_restore
        if ($LASTEXITCODE -ne 0) { Fail "Could not create wellwish_restore" }
        docker @Compose cp $file.FullName "db:/tmp/restore.dump" *> $null
        $code = Invoke-Native "docker" ($Compose + @("exec", "-T", "db", "pg_restore", "-U", "wellwish", "-d", "wellwish_restore",
            "--no-owner", "--exit-on-error", "/tmp/restore.dump"))
        docker @Compose exec -T db rm -f /tmp/restore.dump *> $null
        if ($code -ne 0) { Fail "pg_restore failed" }
        $expected = @(Get-Content $countsFile | Where-Object { $_ })
        $restored = @(Get-Content (Join-Path $Root "infra\postgres\row_counts.sql") -Raw |
            docker @Compose exec -T db psql -U wellwish -d wellwish_restore -At -F " " | Where-Object { $_ })
        if ($expected.Count -eq 0) { Fail "$countsFile is empty: nothing to compare against" }
        if ($restored.Count -eq 0) { Fail "Could not count the rows of the restored tables" }
        $diff = Compare-Object $expected $restored
        if ($diff) { $diff | Format-Table | Out-Host; Fail "The restored rows differ from the backup's" }
        Say "All $($expected.Count) tables have the same rows as when backed up"
        # a backup older than the code is brought up to date, as a real restore would be
        $restoreDb = @("exec", "-T", "-e", "DATABASE_URL=postgres://wellwish:wellwish@db:5432/wellwish_restore", "api")
        $code = Invoke-Native "docker" ($Compose + $restoreDb + @("python", "manage.py", "migrate", "--noinput"))
        if ($code -ne 0) { Fail "The newer migrations could not be applied to the restored database" }
        $code = Invoke-Native "docker" ($Compose + $restoreDb + @("python", "manage.py", "migrate", "--check"))
        if ($code -ne 0) { Fail "The restored database is missing migrations" }
        Say "Every migration is applied in the restored database"
        docker @Compose exec -T db dropdb -U wellwish --force wellwish_restore *> $null
        Say "Restore test passed (wellwish_restore removed again)"
    }
    "pin" {
        Ensure-Docker
        Say "Re-pinning backend\requirements\*.txt with pip-compile (Python 3.13)"
        $req = Join-Path $Root "backend\requirements"
        $code = Invoke-Native "docker" @("run", "--rm", "-v", "${req}:/req", "-w", "/req", "python:3.13-slim", "sh", "-c",
            "pip install -q pip-tools && pip-compile -q --strip-extras --no-emit-index-url base.in -o base.txt && pip-compile -q --strip-extras --no-emit-index-url dev.in -o dev.txt")
        if ($code -ne 0) { Fail "pip-compile failed" }
        Say "Pinned. Rebuild with: .\ww.ps1 up"
    }
    "reset-db" {
        Ensure-Docker
        Say "Deleting the local database volume (all local data is lost)"
        docker @Compose down -v
        Say "Run .\ww.ps1 up to start again with an empty database"
    }
    default {
        Write-Host @"
WellWish developer commands (.\ww.ps1 <command>)

  up              Start backend containers (waits until healthy) + admin panel window
  down            Stop everything
  restart [svc]   Restart containers (e.g. .\ww.ps1 restart worker)
  ps              Show container status
  logs [svc]      Follow logs (e.g. .\ww.ps1 logs api)
  shell           Django shell in the api container
  manage <args>   Any manage.py command (e.g. .\ww.ps1 manage createsuperuser)
  migrate         Apply migrations
  makemigrations  Create migrations for model changes
  seed            Load development seed data
  test [args]     Run backend tests (pytest)
  lint            ruff + format check + mypy
  format          Auto-format backend code
  check           ALL checks: backend, Flutter, admin (run before finishing a phase)
  openapi         Export docs\api\openapi.json from the backend
  gen-clients     Regenerate the Dart client (packages\ww_api) and admin TypeScript types
  build <app> [flavor] [apk|appbundle]
                  Obfuscated release build of the patient or partner app (default prod, apk)
  backup          Copy the local database and uploads to backups\ (with row counts)
  restore-test [file]
                  Restore a backup into a separate database and check every table
  loadtest [min] [workers]
                  Load test: 100 partners' live location + 30 bookings/min (own database)
  s3-test         Uploads against a real S3 API (a test store in Docker): size and type limits
  pin             Re-pin backend requirements after editing *.in files
  reset-db        Delete the local database (asks Docker to remove the volume)
"@
    }
}
