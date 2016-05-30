create or replace package body oos_issue_91 is
  function to_char(p_val in boolean) return varchar2 is
  begin
    if p_val is null then return 'NULL'; end if;
    
    return case p_val
      when true then 'TRUE'
      else 'FALSE'
    end;
  end;

  function kvn(p_key in varchar2, p_value in varchar2) return varchar2 is
  begin
    return '(' || p_key || ' = ' || nvl(p_value, 'NULL') || ')';
  end;

  function kvn(p_key in varchar2, p_value in number) return varchar2 is
  begin
    return '(' || p_key || ' = ' ||
      nvl(standard.to_char(p_value), 'NULL') || ')';
  end;

  function kvn(p_key in varchar2, p_value in date,
               p_fmt in varchar2 default 'YYYY-MM-DD HH24:MI:SS')
    return varchar2 is
  begin
    return '(' || p_key || ' = ' ||
      nvl(standard.to_char(p_value, p_fmt), 'NULL') || ')';
  end;

  function kvn(p_key in varchar2, p_value in boolean) return varchar2 is
  begin
    return '(' || p_key || ' = ' || oos_issue_91.to_char(p_value) || ')';
  end;

  function kv(p_key in varchar2, p_value in varchar2) return varchar2 is
  begin
    if p_value is null then return null; end if;
    return kvn(p_key, p_value);
  end;

  function kv(p_key in varchar2, p_value in number) return varchar2 is
  begin
    if p_value is null then return null; end if;
    return kvn(p_key, p_value);
  end;

  function kv(p_key in varchar2, p_value in date,
              p_fmt in varchar2 default 'YYYY-MM-DD HH24:MI:SS')
    return varchar2 is
  begin
    if p_value is null then return null; end if;
    return kvn(p_key, p_value, p_fmt);
  end;

  function kv(p_key in varchar2, p_value in boolean) return varchar2 is
  begin
    if p_value is null then return null; end if;
    return kvn(p_key, p_value);
  end;
end;
/
show errors