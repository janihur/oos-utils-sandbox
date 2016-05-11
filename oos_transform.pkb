create or replace package body oos_transform is

  function refcur2xml(
    p_rc in sys_refcursor
   ,p_null_handling in number default dbms_xmlgen.null_attr
  ) return xmltype is
    l_context dbms_xmlgen.ctxhandle;
    l_xml xmltype;
  begin
    l_context := dbms_xmlgen.newcontext(p_rc);
   
    dbms_xmlgen.setnullhandling(l_context, p_null_handling);
   
    l_xml := dbms_xmlgen.getxmltype(l_context, dbms_xmlgen.none);

    dbms_xmlgen.closecontext(l_context);

    return l_xml;
  end;

  function xslt(p_in in xmltype, p_trans in xmltype) return xmltype is
  begin
    return p_in.transform(p_trans);
  end;

  function xquery(p_in in xmltype, p_trans in varchar2) return xmltype is
    l_out xmltype;
  begin
    select xmlquery(p_trans passing p_in returning content) into l_out from dual;
    return l_out;
  end;

end;
/
show errors
