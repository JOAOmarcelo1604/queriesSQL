SELECT 'ALTER SYSTEM KILL SESSION  ''' || se.sid || ',
' || se.serial# || ''' IMMEDIATE ;'
FROM v$session se where trunc(last_call_et/60) > &tempo  and USERNAME = '&usuario';
