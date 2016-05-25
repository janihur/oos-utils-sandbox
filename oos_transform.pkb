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

  function refcur2csv(
    p_rc in sys_refcursor
   ,p_column_names in boolean default false
  ) return clob is
    v_xml1 xmltype;
    v_xml2 xmltype;
    -- see: http://stackoverflow.com/questions/14088881/xml-to-csv-conversion-using-xquery
    v_xquery constant varchar2(32767) := q'[
let $nl := codepoints-to-string(10),
    $q := codepoints-to-string(34),
    $nodes := /ROWSET/ROW
for $i in $nodes
   return concat(string-join($i/*/concat($q, normalize-space(replace(data(.), $q, concat($q,$q))), $q), ','),$nl)
]';
    v_xquery_names constant varchar2(32767) := q'[
let $nl := codepoints-to-string(10),
    $q := codepoints-to-string(34),
    $nodes := /ROWSET/ROW
    return concat(
              string-join(distinct-values($nodes/*/concat($q, name(.), $q)), ','),
              $nl,
              string-join(
                 for $i in $nodes
                    return string-join($i/*/concat($q, normalize-space(replace(data(.), $q, concat($q,$q))), $q),','),$nl),
              $nl
           )
]';
  begin
    v_xml1 := refcur2xml(p_rc);

    if p_column_names
    then
      v_xml2 := xquery(v_xml1, v_xquery_names);
    else
      v_xml2 := xquery(v_xml1, v_xquery);
    end if;
    return entity_decode(v_xml2.getclobval());
  end;

  function refcur2csv2(
    p_rc           in out sys_refcursor
   ,p_column_names in boolean default false
   ,p_separator    in varchar2 default ','
   ,p_endline      in varchar2 default chr(13)||chr(10)
   ,p_date_fmt     in varchar2 default 'YYYY-MM-DD HH24:MI:SS'
  ) return clob is
    v_lob clob;
    v_cur_id pls_integer;
    v_col_count pls_integer;
    v_col_desc dbms_sql.desc_tab3;

    v_var_varchar2 varchar2(32767);
    v_var_number number;
    v_var_date date;

    v_buf varchar2(32767);

    procedure print(p_rec in dbms_sql.desc_rec3) is
    begin
      dbms_output.new_line;
      dbms_output.put_line('---------------------');
      dbms_output.put_line('col_type            = '
                           || p_rec.col_type);
      dbms_output.put_line('col_maxlen          = '
                           || p_rec.col_max_len);
      dbms_output.put_line('col_name            = '
                           || p_rec.col_name);
      dbms_output.put_line('col_name_len        = '
                           || p_rec.col_name_len);
      dbms_output.put_line('col_schema_name     = '
                           || p_rec.col_schema_name);
      dbms_output.put_line('col_schema_name_len = '
                           || p_rec.col_schema_name_len);
      dbms_output.put_line('col_precision       = '
                           || p_rec.col_precision);
      dbms_output.put_line('col_scale           = '
                           || p_rec.col_scale);
      dbms_output.put_line('col_charsetid       = '
                           || p_rec.col_charsetid);
      dbms_output.put_line('col_charsetform     = '
                           || p_rec.col_charsetform);
      dbms_output.put_line('col_type_name       = '
                           || p_rec.col_type_name);
      dbms_output.put_line('col_type_name_len   = '
                           || p_rec.col_type_name_len);
      dbms_output.put     ('col_null_ok         = ');
      if (p_rec.col_null_ok) then
        dbms_output.put_line('true');
      else
        dbms_output.put_line('false');
      end if;
    end;
  begin
    dbms_lob.createtemporary(lob_loc => v_lob,
                             cache   => false,
                             dur     => dbms_lob.call);

    v_cur_id := dbms_sql.to_cursor_number(p_rc);

    dbms_sql.describe_columns3(v_cur_id, v_col_count, v_col_desc);

    if p_column_names
    then
      for i in 1 .. v_col_count
      loop
        v_buf := '"' || v_col_desc(i).col_name || '"';
        if i < v_col_count
        then
          v_buf := v_buf || p_separator;
        end if;
        dbms_lob.writeappend(v_lob, length(v_buf), v_buf);
      end loop;
      dbms_lob.writeappend(v_lob, length(p_endline), p_endline);
    end if;

    for i in 1 .. v_col_count
    loop
      -- print(v_col_desc(i));
      case v_col_desc(i).col_type
        -- TODO: where to find all the numbers ?
        -- See https://docs.oracle.com/cd/B10501_01/server.920/a96540/sql_elements2a.htm#45504
        when  1 then dbms_sql.define_column(v_cur_id, i, v_var_varchar2, 32767);
        when  2 then dbms_sql.define_column(v_cur_id, i, v_var_number);
        when 12 then dbms_sql.define_column(v_cur_id, i, v_var_date);
        when 96 then dbms_sql.define_column(v_cur_id, i, v_var_varchar2, 32767);
        else         dbms_sql.define_column(v_cur_id, i, v_var_varchar2, 32767);
      end case;
    end loop;

    -- TODO: A (double) quote character in a field must be represented by two
    -- (double) quote characters.
    -- CSV doesn't care about single quote characters. Only replace double quotes
    -- using the regexp_replace below.
    while dbms_sql.fetch_rows(v_cur_id) > 0
    loop
      for i in 1 .. v_col_count
      loop
        case v_col_desc(i).col_type
          when  2 then
            dbms_sql.column_value(v_cur_id, i, v_var_number);
            -- dbms_output.put_line('v_var_number = ' || v_var_number);
            v_buf := to_char(v_var_number); -- TODO format model
          when 12 then
            dbms_sql.column_value(v_cur_id, i, v_var_date);
            -- dbms_output.put_line('v_var_date = ' || v_var_date);
            v_buf := '"' || to_char(v_var_date, p_date_fmt) || '"';
          when 96 then
            dbms_sql.column_value(v_cur_id, i, v_var_varchar2);
            -- dbms_output.put_line('v_var_varchar2 = ' || v_var_varchar2);
            v_buf := '"' || regexp_replace(v_var_varchar2, '(' || chr(34) || ')', '\1' || '\1') || '"';
          else
            dbms_sql.column_value(v_cur_id, i, v_var_varchar2);
            -- dbms_output.put_line('v_var_varchar2 = ' || v_var_varchar2);
            v_buf := '"' || regexp_replace(v_var_varchar2, '(' || chr(34) || ')', '\1' || '\1') || '"';
        end case;
        if i < v_col_count
        then
          v_buf := v_buf || p_separator;
        end if;
        dbms_lob.writeappend(v_lob, length(v_buf), v_buf);
      end loop;
      dbms_lob.writeappend(v_lob, length(p_endline), p_endline);
    end loop;

    return v_lob;
  end;

  function entity_decode(p_in clob) return clob
  is
  begin
    return dbms_xmlgen.convert(p_in, dbms_xmlgen.entity_decode);
  end;
end;
/
show errors
