function [gps_week, sec_of_week]=ymdhms2gps(year, month, mday, hour, minute, second);
  month_day = [0 31 59 90 120 151 181 212 243 273 304 334; 0 31 60 91 121 152 182 213 244 274 305 335];
  yday = month_day(leapyear(year) + 1, month) + mday;
  mjd = fix((year - 1901)/4)*1461 + mod((year - 1901), 4)*365 + yday - 1 + 15385;
  fmjd = ((second/60.0 + minute)/60.0 + hour)/24.0;
  gps_week = fix((mjd - 44244)/7);
  sec_of_week = ( (mjd - 44244) - gps_week*7 + fmjd )*86400;
endfunction