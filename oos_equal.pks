create or replace package oos_equal is

  function is_(
    p_a in varchar2
   ,p_b in varchar2
  ) return boolean;

  function is_(
    p_a in number
   ,p_b in number
  ) return boolean;

  function is_(
    p_a in date
   ,p_b in date
  ) return boolean;

  function "not"(
    p_a in varchar2
   ,p_b in varchar2
  ) return boolean;

  function "not"(
    p_a in number
   ,p_b in number
  ) return boolean;

  function "not"(
    p_a in date
   ,p_b in date
  ) return boolean;

end;
/
show errors
