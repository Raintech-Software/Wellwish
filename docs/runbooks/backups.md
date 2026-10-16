# Backups and restore (runbook)

ARCHITECTURE §12 *Backups*: daily database snapshots, 7-day point-in-time restore, a restore test every month. Written in Phase 9.6 (13 Oct 2026). The server parts start in Phase 10, once the AWS account exists (KEYS-AND-ACCOUNTS #8–#10).

## What is backed up, and where

| Data | Where it lives | Backup | Kept |
|---|---|---|---|
| Database (accounts, bookings, payments, audit log…) | RDS PostgreSQL 16 | RDS **automated backups**: a daily snapshot + transaction logs, so any moment of the last 7 days can be restored | 7 days (`BackupRetentionPeriod = 7`) |
| Database before a release | RDS | a **manual snapshot** `wellwish-prod-before-<version>` | until the next release works |
| Files (ID documents, prescriptions, photos) | S3, private, KMS-encrypted | **S3 versioning**: a deleted or replaced file keeps its old version | old versions expire after 7 days (lifecycle rule) |
| Redis (live locations, rate limits, caches) | ElastiCache / Redis | not backed up: everything there is short-lived and rebuilt | — |
| Secrets | AWS Secrets Manager | versioned by AWS | — |

**Personal data in backups.** A deleted account (§12 *Privacy*) is erased from the live database after the waiting time (`account_deletion_days`, default 7 days, during which logging in keeps the account). Its rows then stay in the backups until they age out: 7 more days for both the database and the files. So the data is gone from everything at most the waiting time + 7 days after the request. Consent and payment records are kept, as the law requires. Say so if someone asks when their data is gone.

## Set-up on a server (Phase 10)

1. RDS instance: *Backup retention* **7 days**, a backup window at night (e.g. 20:30–21:00 UTC = 02:00–02:30 IST), *Copy tags to snapshots*, *Deletion protection* on, encryption on (KMS).
2. S3 bucket: *Versioning* on; lifecycle rule "expire non-current versions after 7 days" and "delete expired object delete markers".
3. CloudWatch: RDS's own `FreeStorageSpace` alarm (besides the §13 alarms in `infra/cloudwatch/alarms.json`).

## Monthly restore test (staging, and production's snapshots)

Do it on the first working day of the month, and after any change to the database set-up. Write the result in the log at the end.

1. **Restore** the newest moment into a new, temporary instance (never over the real one):
   ```bash
   aws rds restore-db-instance-to-point-in-time \
     --source-db-instance-identifier wellwish-staging \
     --target-db-instance-identifier wellwish-restore-test \
     --use-latest-restorable-time \
     --db-instance-class db.t4g.micro --no-publicly-accessible \
     --vpc-security-group-ids <the database security group> --db-subnet-group-name <the subnet group>
   aws rds wait db-instance-available --db-instance-identifier wellwish-restore-test
   ```
2. **Check it** from the API server (it can reach the database's network):
   ```bash
   # every table and its rows: compare with the same query on the live database
   psql "postgres://…@wellwish-restore-test…/wellwish" -At -F " " -f infra/postgres/row_counts.sql > restored.txt
   psql "postgres://…@wellwish-staging…/wellwish"      -At -F " " -f infra/postgres/row_counts.sql > live.txt
   diff live.txt restored.txt   # only tables written since the restore moment may differ, by a little
   # the app sees a complete database: every migration applied
   DATABASE_URL="postgres://…@wellwish-restore-test…/wellwish" python manage.py migrate --check
   ```
   Pass: every table is there, the row counts match (or differ only by the last minutes' writes), `migrate --check` exits 0.
3. **Files:** pick a document from the admin panel, delete a test copy of it in S3, restore its previous version (*Show versions* → download / copy back), and open it again.
4. **Delete** the temporary instance:
   ```bash
   aws rds delete-db-instance --db-instance-identifier wellwish-restore-test --skip-final-snapshot
   ```

## Restoring for real (production incident)

1. Stop the writers first: the API, the Celery worker and beat (so nothing writes to the old database meanwhile).
2. Restore to a **new** instance at the moment before the problem (step 1 above, with `--restore-time 2026-…Z` instead of `--use-latest-restorable-time`).
3. Check it (step 2 above), then point `DATABASE_URL` (Secrets Manager) at the new instance and start the API, worker and beat.
4. Keep the old instance (stopped) until the cause is understood; then delete it.
5. Payments made in the gap: Razorpay keeps them. The `payments.reconcile` job (every 10 minutes) asks Razorpay about unconfirmed payments and finishes them.

## On the developer's PC

```powershell
.\ww.ps1 backup                 # backups\wellwish-<date>.dump + .counts.txt + -media.zip (git-ignored)
.\ww.ps1 restore-test           # restores the newest backup into wellwish_restore and checks it
.\ww.ps1 restore-test backups\wellwish-20261013-162140.dump
```

`restore-test` restores into a separate database (`wellwish_restore`) and passes when every table has the rows it had at backup time and every migration is applied. Your dev database is never touched. A failed test leaves `wellwish_restore` behind so you can look at it; the next run replaces it.

To really put a backup back into the dev database (this replaces your local data):

```powershell
docker compose -f infra/docker-compose.yml stop api worker beat
docker compose -f infra/docker-compose.yml exec -T db dropdb -U wellwish --force wellwish
docker compose -f infra/docker-compose.yml exec -T db createdb -U wellwish wellwish
docker compose -f infra/docker-compose.yml cp backups\wellwish-<date>.dump db:/tmp/restore.dump
docker compose -f infra/docker-compose.yml exec -T db pg_restore -U wellwish -d wellwish --no-owner /tmp/restore.dump
.\ww.ps1 up
```

Then unzip `-media.zip` into `backend\media` for the uploads.

## Restore test log

| Date | Environment | Backup restored | Result | By |
|---|---|---|---|---|
| 13 Oct 2026 | local (developer PC) | `wellwish-20261013-162140.dump` (64 tables) | ✅ all rows match, every migration applied; a backup with a wrong count was caught | Claude (Phase 9.6) |
| 14 Oct 2026 | local (developer PC) | `wellwish-20261014-110001.dump` (64 tables, 21,267 upload files) | ✅ all rows match, every migration applied, the uploads zip complete | Claude (Phase 9 close) |
| — | server | — | ⬜ the first one at the developer's deploy (Phase 10.1) | — |
