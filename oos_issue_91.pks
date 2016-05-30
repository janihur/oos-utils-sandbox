create or replace package oos_issue_91 is
  function to_char(p_val in boolean) return varchar2;

  --
  -- Return a string: (p_key = p_value) and if p_value is null: (p_key =
  -- NULL). Useful for logging.
  --

  function kvn(p_key in varchar2, p_value in varchar2) return varchar2;
  function kvn(p_key in varchar2, p_value in number) return varchar2;
  function kvn(p_key in varchar2, p_value in date,
               p_fmt in varchar2 default 'YYYY-MM-DD HH24:MI:SS')
    return varchar2;
  function kvn(p_key in varchar2, p_value in boolean) return varchar2;

  --
  -- Return a string: (p_key = p_value) and empty string (null) if p_value is
  -- null. Useful for logging.
  --

  function kv(p_key in varchar2, p_value in varchar2) return varchar2;
  function kv(p_key in varchar2, p_value in number) return varchar2;
  function kv(p_key in varchar2, p_value in date,
              p_fmt in varchar2 default 'YYYY-MM-DD HH24:MI:SS')
    return varchar2;
  function kv(p_key in varchar2, p_value in boolean) return varchar2;
end;
/
show errors