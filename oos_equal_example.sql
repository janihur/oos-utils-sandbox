declare
  function to_str(p_a in boolean) return varchar2 is
  begin
    return
      case p_a
        when true then 'TRUE'
        when false then 'FALSE'
        else 'NULL'
      end;
  end;
  procedure test(p_a in number, p_b in number) is
    v_res boolean := oos_equal.is_(p_a, p_b);
  begin
    dbms_output.put_line(
      '(p_a ' || p_a || ')(p_b ' || p_b || ')(v_res ' || to_str(v_res) || ')'
    );
  end;
begin
  test(to_number(null), to_number(null));
  test(null, 1);
  test(1, null);
  test(1, 1);
  test(1, 2);
end;
/
