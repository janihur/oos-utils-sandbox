create or replace package oos_transform is

  -- converts a ref cursor to a canonical oracle xml
  -- p_null_handling is an example how conversion can be configured
  -- this is just a wrapper for dbms_xmlgen so refer to oracle documentation
  -- http://docs.oracle.com/cd/E11882_01/appdev.112/e40758/d_xmlgen.htm
  function refcur2xml(
    p_rc in sys_refcursor
   ,p_null_handling in number default dbms_xmlgen.null_attr
  ) return xmltype;

  -- transforms a canonical oracle xml with user provided xslt
  function xslt(p_in in xmltype, p_trans in xmltype) return xmltype;

  -- transforms a canonical oracle xml with user provided xquery
  function xquery(p_in in xmltype, p_trans in varchar2) return xmltype;

  -- transforms a ref cursor to csv (xquery implementation)
  function refcur2csv(
    p_rc in sys_refcursor
  ) return clob;

  -- transforms a ref cursor to csv (dbms_sql implementation)
  function refcur2csv2(
    p_rc        in out sys_refcursor
   ,p_separator in varchar2 default ','
   ,p_endline   in varchar2 default chr(10)||chr(13)
   ,p_date_fmt  in varchar2 default 'YYYY-MM-DD HH24:MI:SS'
  ) return clob;

end;
/
show errors
