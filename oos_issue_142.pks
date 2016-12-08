create or replace package oos_issue_142 is
  gc_fmt_b  constant varchar2(1) := 'B';
  gc_fmt_kb constant varchar2(2) := 'KB';
  gc_fmt_mb constant varchar2(2) := 'MB';
  gc_fmt_gb constant varchar2(2) := 'GB';
  gc_fmt_tb constant varchar2(2) := 'TB';
  gc_fmt_pb constant varchar2(2) := 'PB';
  gc_fmt_eb constant varchar2(2) := 'EB';
  gc_fmt_zb constant varchar2(2) := 'ZB';
  gc_fmt_yb constant varchar2(2) := 'YB';

  gc_scaling_si  constant varchar2(2) := 'SI';
  gc_scaling_iec constant varchar2(3) := 'IEC';

  function to_human(
    p_num in number
   ,p_fmt in varchar2 default null
   ,p_scaling in varchar2 default gc_scaling_si
  ) return varchar2;
end;
/
show errors
