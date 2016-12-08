create or replace package body oos_issue_142 is
  type num_list_t is table of number;
  type limits_t is table of num_list_t index by varchar2(3);
  v_limits limits_t;

  gc_size_b  constant number := 1;
  gc_size_kb constant number := 2;
  gc_size_mb constant number := 3;
  gc_size_gb constant number := 4;
  gc_size_tb constant number := 5;
  gc_size_pb constant number := 6;
  gc_size_eb constant number := 7;
  gc_size_zb constant number := 8;
  gc_size_yb constant number := 9;

  function to_human(
    p_num in number
   ,p_fmt in varchar2 default null
   ,p_scaling in varchar2 default gc_scaling_si
  ) return varchar2 is
    l_fmt varchar2(255);
    l_basic_size constant number := v_limits(p_scaling)(gc_size_b);
  begin
    if p_num is null then
      return null;
    end if;

    -- List of formats: http://www.gnu.org/software/coreutils/manual/coreutils
    l_fmt := nvl(upper(p_fmt),
      case
        when p_num < v_limits(p_scaling)(gc_size_b)  then gc_fmt_b
        when p_num < v_limits(p_scaling)(gc_size_kb) then gc_fmt_kb
        when p_num < v_limits(p_scaling)(gc_size_mb) then gc_fmt_mb
        when p_num < v_limits(p_scaling)(gc_size_gb) then gc_fmt_gb
        when p_num < v_limits(p_scaling)(gc_size_tb) then gc_fmt_tb
        when p_num < v_limits(p_scaling)(gc_size_pb) then gc_fmt_pb
        when p_num < v_limits(p_scaling)(gc_size_eb) then gc_fmt_eb
        when p_num < v_limits(p_scaling)(gc_size_zb) then gc_fmt_zb
        else                                              gc_fmt_yb
      end
    );

    return
      trim(
        sys.standard.to_char(
        round(
          case l_fmt
            when gc_fmt_b  then p_num/(v_limits(p_scaling)(gc_size_b) /l_basic_size)
            when gc_fmt_kb then p_num/(v_limits(p_scaling)(gc_size_kb)/l_basic_size)
            when gc_fmt_mb then p_num/(v_limits(p_scaling)(gc_size_mb)/l_basic_size)
            when gc_fmt_gb then p_num/(v_limits(p_scaling)(gc_size_gb)/l_basic_size)
            when gc_fmt_tb then p_num/(v_limits(p_scaling)(gc_size_tb)/l_basic_size)
            when gc_fmt_pb then p_num/(v_limits(p_scaling)(gc_size_pb)/l_basic_size)
            when gc_fmt_eb then p_num/(v_limits(p_scaling)(gc_size_eb)/l_basic_size)
            when gc_fmt_zb then p_num/(v_limits(p_scaling)(gc_size_zb)/l_basic_size)
            else                p_num/(v_limits(p_scaling)(gc_size_yb)/l_basic_size)
          end, 1)
        ,
        -- Number format
        '999G999G999G999G999G999G999G999G999' ||
          case
            when l_fmt != gc_fmt_b then 'D9'
            else null
          end)
        )
      || ' ' || l_fmt;
  end;

begin
  v_limits(gc_scaling_si) := num_list_t(
          1000
   ,power(1000, 2)
   ,power(1000, 3)
   ,power(1000, 4)
   ,power(1000, 5)
   ,power(1000, 6)
   ,power(1000, 7)
   ,power(1000, 8)
   ,power(1000, 9)
  );

  v_limits(gc_scaling_iec) := num_list_t(
          1024
   ,power(1024, 2)
   ,power(1024, 3)
   ,power(1024, 4)
   ,power(1024, 5)
   ,power(1024, 6)
   ,power(1024, 7)
   ,power(1024, 8)
   ,power(1024, 9)
  );
end;
/
show errors
