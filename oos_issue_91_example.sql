begin
  dbms_output.put_line(oos_issue_91.to_char(true));
  dbms_output.put_line(oos_issue_91.to_char(false));
  dbms_output.put_line(oos_issue_91.to_char(null));
end;
/

declare
  v_foo number := 42;
begin
  dbms_output.put_line(oos_issue_91.kv('v_foo', v_foo));
  dbms_output.put_line(oos_issue_91.kvn('v_foo', v_foo));

  v_foo := null;
  
  dbms_output.put_line(oos_issue_91.kv('v_foo', v_foo));
  dbms_output.put_line(oos_issue_91.kvn('v_foo', v_foo));
end;
/

declare
  v_foo date := sysdate;
begin
  dbms_output.put_line(oos_issue_91.kv('v_foo', v_foo));
  dbms_output.put_line(oos_issue_91.kvn('v_foo', v_foo));
end;
/

declare
  v_foo boolean := true;
begin
  dbms_output.put_line(oos_issue_91.kv('v_foo', v_foo));
  dbms_output.put_line(oos_issue_91.kvn('v_foo', v_foo));

  v_foo := false;

  dbms_output.put_line(oos_issue_91.kv('v_foo', v_foo));
  dbms_output.put_line(oos_issue_91.kvn('v_foo', v_foo));

  v_foo := null;

  dbms_output.put_line(oos_issue_91.kv('v_foo', v_foo));
  dbms_output.put_line(oos_issue_91.kvn('v_foo', v_foo));
end;
/

--
-- an example how to use kv- and kvn-functions to build a stringification of
-- an user defined pl/sql record type
--

-- TODO: change example to a package and implement conditional compilation in
-- to_char functions

declare
  type foo_t is record (
    a number
   ,b varchar2(10)
   ,c date
   ,d boolean
  );

  type foos_t is table of foo_t;

  function mk_foo_t(p_a in number, p_b in varchar2,
                    p_c in date, p_d in boolean) return foo_t is
    v_foo foo_t;
  begin
    v_foo.a := p_a;
    v_foo.b := p_b;
    v_foo.c := p_c;
    v_foo.d := p_d;

    return v_foo;
  end;

  function to_char(p_foo in foo_t) return varchar2 is
  begin
    return
         '('
      || oos_issue_91.kvn('a', p_foo.a)
      || oos_issue_91.kvn('b', p_foo.b)
      || oos_issue_91.kvn('c', p_foo.c)
      || oos_issue_91.kvn('d', p_foo.d)
      || ')'
    ;
  end;

  function to_char(p_foos in foos_t) return varchar2 is
    v_str varchar2(32767);
  begin
    for i in p_foos.first .. p_foos.last
    loop
      v_str := v_str || '(' || i || ' = ' || to_char(p_foos(i)) || ')';
    end loop;
    return v_str;
  end;
begin
  declare
    v_foos foos_t := foos_t(mk_foo_t(1, 'AA', sysdate, true),
                            mk_foo_t(2, 'BB', sysdate + 1, false));
  begin
    dbms_output.put_line(to_char(v_foos));
  end;
end;
/
