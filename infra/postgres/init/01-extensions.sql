-- Runs once, when the database volume is first created.
-- btree_gist powers the "no double-booking a partner" rule (ARCHITECTURE §6.9).
-- Adding it to template1 too means pytest's test database gets it automatically.
CREATE EXTENSION IF NOT EXISTS btree_gist;
\connect template1
CREATE EXTENSION IF NOT EXISTS btree_gist;
