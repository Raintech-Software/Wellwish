"""Make audit_log append-only in the database itself (ARCHITECTURE §9.1: nobody can change it).

UPDATE and DELETE raise an error even from raw SQL or the Django shell. TRUNCATE is left
alone because the test runner empties tables with it; in production the API's database user
must not own the table (Phase 10 hardening), so it can't truncate either.
"""

from django.db import migrations

FORWARD = """
CREATE OR REPLACE FUNCTION audit_log_block_changes() RETURNS trigger AS $$
BEGIN
    RAISE EXCEPTION 'audit_log is append-only';
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER audit_log_no_update_delete
    BEFORE UPDATE OR DELETE ON audit_log
    FOR EACH ROW EXECUTE FUNCTION audit_log_block_changes();
"""

BACKWARD = """
DROP TRIGGER IF EXISTS audit_log_no_update_delete ON audit_log;
DROP FUNCTION IF EXISTS audit_log_block_changes();
"""


class Migration(migrations.Migration):
    dependencies = [("audit", "0001_initial")]

    operations = [migrations.RunSQL(FORWARD, BACKWARD)]
