declare
  v_rc sys_refcursor;
  v_xml1 xmltype;
  v_xml2 xmltype;
  v_xslt constant xmltype := xmltype(q'[<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
 <xsl:output method="html"/>
 <xsl:template match="/">
 <table>
   <thead>
     <tr>
      <xsl:for-each select="/ROWSET/ROW[1]/*">
       <th><xsl:value-of select="name()"/></th>
      </xsl:for-each>
     </tr>
   </thead>
   <tbody>
     <xsl:for-each select="/ROWSET/*">
      <tr>
       <xsl:for-each select="./*">
        <td><xsl:value-of select="text()"/></td>
       </xsl:for-each>
      </tr>
     </xsl:for-each>
  </tbody>
 </table>
 </xsl:template>
</xsl:stylesheet>]');
  v_xquery constant varchar2(32767) := q'[<table>
  <thead>
    <tr>
    {
      for $i in /ROWSET/ROW[1]/*
      return
      <th>{name($i)}</th>
    }
    </tr>
  </thead>
  <tbody>
  {
    for $i in /ROWSET/*
    return
    <tr>
    {
      for $j in $i/*
      return
      <td>{data($j)}</td>
    }
    </tr>
  }
  </tbody>
</table>]';
begin
  open v_rc for
    select level, dummy from dual
    connect by level < 4
  ;
  
  v_xml1 := oos_transform.refcur2xml(v_rc);
  dbms_output.put_line(v_xml1.getclobval());

  v_xml2 := oos_transform.xslt(v_xml1, v_xslt);
  dbms_output.put_line(v_xml2.getclobval());

  v_xml2 := oos_transform.xquery(v_xml1, v_xquery);
  dbms_output.put_line(v_xml2.getclobval());
end;
/
