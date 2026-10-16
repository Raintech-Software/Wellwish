-- Every table of the WellWish database with its exact number of rows ("table rows", sorted).
-- Used by .\ww.ps1 backup / restore-test (PHASES 9.6) to prove a restore brought everything back.
SELECT table_name,
       (xpath('/row/c/text()',
              query_to_xml(format('SELECT count(*) AS c FROM public.%I', table_name), false, true, '')))[1]::text::bigint
FROM information_schema.tables
WHERE table_schema = 'public' AND table_type = 'BASE TABLE'
ORDER BY table_name;
