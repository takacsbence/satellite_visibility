clear all;
clc;

#read almanac file
[prn, health, ecc, ax, raw, aop, man, toa, inc, rra, week] = read_trimble_almanac('almanac2210.alm');
nalm = columns(prn);
fprintf('%d almanac read\n', nalm);

#time
[gps_week, sec_of_week] = ymdhms2gps(2022, 5, 17, 6, 0, 0);

#station coordinates, somewhere in Budapest
lat=deg2rad(47.5);
lon=deg2rad(19.0);
alt=0.0;

#elevation cut off angle
cutoff = 10;

[xsta(1) xsta(2) xsta(3)] = lla2ecef(lat,lon,alt);

%for i = 1:nalm
for i = 72:72
  fprintf('i %d\n', i)
  fprintf('prn %d\n', prn(i))
  %fprintf('%.3f\n', ax(i))

  ax(i) = (sqrt(29600000) + 0.025390625)^2;
  ecc(i) = 0.0002899169921875;
  inc(i) = 56*pi/180-0.00103759765625000390312782094782*pi;
  raw(i) = 0.16717529296874997224442438371*pi;
  aop(i) = 0.09860229492188849452108096757*pi;
  man(i) = 0.753967285156276867397195928788*pi;
  toa(i) = 204000;

  %fprintf('%.3f\n', ax(i))
  #calculate satellite position
  xsat = satpos(gps_week, sec_of_week, i, prn, health, ecc, ax, raw, aop, man, toa, inc, rra, week);

  #calculate azimuth and elevation
  [Ele, Azi] = Calc_Azimuth_Elevation(xsta, xsat);
        
  %fprintf('%d %.3f %.3f %.3f\n', prn(i), xsat(1), xsat(2), xsat(3));  
  fprintf('%d %d %.1f %.1f\n', i, prn(i), Ele, Azi);
  
endfor