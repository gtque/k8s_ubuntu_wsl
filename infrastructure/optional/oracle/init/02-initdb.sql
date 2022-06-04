
-- GP DB build settings..
ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME unlimited;
ALTER PROFILE DEFAULT LIMIT PASSWORD_GRACE_TIME unlimited;
ALTER PROFILE DEFAULT LIMIT PASSWORD_LOCK_TIME unlimited;
ALTER PROFILE DEFAULT LIMIT FAILED_LOGIN_ATTEMPTS unlimited;
GRANT execute on dbms_flashback to public;
GRANT execute on dbms_crypto to public;
GRANT execute on dbms_lock to public;
Alter system set nls_length_semantics='CHAR' scope=both;

-- Create Role...
CREATE ROLE LOCALDEV NOT IDENTIFIED;
GRANT CREATE CLUSTER TO LOCALDEV;
GRANT CREATE INDEXTYPE TO LOCALDEV;
GRANT CREATE OPERATOR TO LOCALDEV;
GRANT CREATE PROCEDURE TO LOCALDEV;
GRANT CREATE SEQUENCE TO LOCALDEV;
GRANT CREATE SESSION TO LOCALDEV;
GRANT CREATE SYNONYM TO LOCALDEV;
GRANT CREATE TABLE TO LOCALDEV;
GRANT CREATE TRIGGER TO LOCALDEV;
GRANT CREATE TYPE TO LOCALDEV;
GRANT CREATE VIEW TO LOCALDEV;
GRANT CREATE JOB TO LOCALDEV;
GRANT FORCE ANY TRANSACTION TO LOCALDEV;
GRANT SELECT_CATALOG_ROLE TO LOCALDEV;

-- Disable advisor jobs
BEGIN
  DBMS_AUTO_TASK_ADMIN.disable(
    client_name => 'auto space advisor',
    operation   => NULL,
    window_name => NULL);
END;
/

BEGIN
  DBMS_AUTO_TASK_ADMIN.disable(
    client_name => 'sql tuning advisor',
    operation   => NULL,
    window_name => NULL);
END;
/

-- Gather system stats
EXEC dbms_stats.gather_system_stats();


exit;
