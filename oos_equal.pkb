create or replace package body oos_equal is

  function is_(
    p_a in varchar2
   ,p_b in varchar2
  ) return boolean is
  begin
    if (p_a is null)     and (p_b is null)     then return true;  end if;
    if (p_a is null)     and (p_b is not null) then return false; end if;
    if (p_a is not null) and (p_b is null)     then return false; end if;
    
    return (p_a = p_b);
  end;

  function is_(
    p_a in number
   ,p_b in number
  ) return boolean is
  begin
    if (p_a is null)     and (p_b is null)     then return true;  end if;
    if (p_a is null)     and (p_b is not null) then return false; end if;
    if (p_a is not null) and (p_b is null)     then return false; end if;
    
    return (p_a = p_b);
  end;

  function is_(
    p_a in date
   ,p_b in date
  ) return boolean is
  begin
    if (p_a is null)     and (p_b is null)     then return true;  end if;
    if (p_a is null)     and (p_b is not null) then return false; end if;
    if (p_a is not null) and (p_b is null)     then return false; end if;
    
    return (p_a = p_b);
  end;

  function "not"(
    p_a in varchar2
   ,p_b in varchar2
  ) return boolean is
  begin
    return not is_(p_a, p_b);
  end;

  function "not"(
    p_a in number
   ,p_b in number
  ) return boolean is
  begin
    return not is_(p_a, p_b);
  end;

  function "not"(
    p_a in date
   ,p_b in date
  ) return boolean is
  begin
    return not is_(p_a, p_b);
  end;

end;
/
show errors
