begin
  if oos_equal.is_(to_number(null), to_number(null))
  then
    dbms_output.put_line('number values are equal');
  end if;

  if oos_equal."not"(1, null)
  then
    dbms_output.put_line('number values are not equal');
  end if;
end;
/