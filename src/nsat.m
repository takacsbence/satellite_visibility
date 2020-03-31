#read almanac file
[prn, health, ecc, ax, raw, aop, man, toa, inc, rra, week] = read_trimble_almanac('almanac2072.alm');
nalm = columns(prn);
fprintf('%d almanac read\n', nalm);

#start time
[gps_week, sec_of_week] = ymdhms2gps(2019, 9, 20, 0, 0, 0);

#sampling in seconds
dsec = 300;
nepoch = fix(86400 / dsec);

#station coordinates
lat=deg2rad(47.5);
lon=deg2rad(19.0);
alt=0.0;

#elevation cut off angle
cutoff = 10;

#output file
fid = fopen('nsat_time.txt', 'w');

for l= 1:1  #36
  %lon = 0;
  for k = 1:1 #72
    sec_of_week = 86400;
    for j= 1:nepoch #do calculations at every epoch
      [xsta(1) xsta(2) xsta(3)] = lla2ecef(lat,lon,alt);
      nG = nR = nE = nC = 0;
      for i = 1:nalm
        #calculate satellite position
        xsat = satpos(gps_week, sec_of_week, i, prn, health, ecc, ax, raw, aop, man, toa, inc, rra, week);

        #calculate azimuth and elevation
        [Ele, Azi] = Calc_Azimuth_Elevation(xsta, xsat);
        
        if Ele > cutoff && health(i) == 0
      #    fprintf('%d %.3f %.3f %.3f\n', prn(i), xsat(1), xsat(2), xsat(3));  
      #    fprintf('%d %.1f %.1f\n', prn(i), Ele, Azi);  
          if prn(i) > 0 && prn(i) < 38
            nG++;
          elseif  prn(i) > 37 && prn(i) < 65
            nR++;
          elseif  prn(i) > 200 && prn(i) < 264
            nE++;
          elseif  prn(i) > 263 && prn(i) < 283
            nC++;
          endif  
        endif
      endfor

      #output number of satellites
	date=gps2ymdhms(gps_week, sec_of_week);
      fprintf(fid, '%d %.1f %.1f %.1f %02d:%02d:%02d %d %d %d %d \n', gps_week, sec_of_week, rad2deg(lat), rad2deg(lon), date(4), date(5), date(6), nG, nG+nR, nG+nR+nE, nG+nR+nE+nC)
%      fprintf(fid, '%d %.1f %.1f %.1f %d %d %d %d \n', gps_week, sec_of_week, rad2deg(lat), rad2deg(lon), nG, nG+nR, nG+nR+nE, nG+nR+nE+nC)
      
      #add 5 minutes to gps seconds
      sec_of_week = sec_of_week + dsec;
    endfor  
    %lon = lon + deg2rad(5);
  endfor
  %lat = lat + deg2rad(5);  
endfor
  
fprintf('%d data written\n', l*k*j);
fclose(fid);