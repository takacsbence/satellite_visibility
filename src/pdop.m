#read almanac file
[prn, health, ecc, ax, raw, aop, man, toa, inc, rra, week] = read_trimble_almanac('almanac.alm');
nalm = columns(prn);
fprintf('%d almanac read\n', nalm);

#start time
[gps_week, sec_of_week] = ymdhms2gps(2018, 10, 8, 0, 0, 0);

#sampling in seconds
dsec = 300;
nepoch = fix(86400 / dsec);

#station coordinates, somewhere in Budapest
lat=deg2rad(47.5);
lon=deg2rad(19);
alt=0.0;

#elevation cut off angle
cutoff = 10;

#output file
fid = fopen('pdop_time.txt', 'w');

#for l= 1:36  #36
#  lon = 0;
#  for k = 1:72 #72
#    sec_of_week = 86400;
    for j= 1:nepoch #do calculations at every epoch
      [xsta(1) xsta(2) xsta(3)] = lla2ecef(lat,lon,alt);

      nG = nR = nE = nC = 0;
      AG = AR = AE = AC = [];
      for i = 1:nalm
        #calculate satellite position
        xsat = satpos(gps_week, sec_of_week, i, prn, health, ecc, ax, raw, aop, man, toa, inc, rra, week);

        #calculate azimuth and elevation
        [Ele, Azi] = Calc_Azimuth_Elevation(xsta, xsat);
        
        if Ele > cutoff && health(i) == 0
          if prn(i) > 0 && prn(i) < 38
      #    fprintf('%d %.3f %.3f %.3f\n', prn(i), xsat(1), xsat(2), xsat(3));  
#            fprintf('%d %.1f %.1f\n', prn(i), Ele, Azi);  
            nG++;
            AG(nG, 1) = sind(Azi)*cosd(Ele);
            AG(nG, 2) = cosd(Azi)*cosd(Ele);
            AG(nG, 3) = sind(Ele);
            AG(nG, 4) = 1;         
          elseif  prn(i) > 37 && prn(i) < 65
            nR++;
            AR(nR, 1) = sind(Azi)*cosd(Ele);
            AR(nR, 2) = cosd(Azi)*cosd(Ele);
            AR(nR, 3) = sind(Ele);
            AR(nR, 4) = 1;         
          elseif  prn(i) > 200 && prn(i) < 264
            nE++;
            AE(nE, 1) = sind(Azi)*cosd(Ele);
            AE(nE, 2) = cosd(Azi)*cosd(Ele);
            AE(nE, 3) = sind(Ele);
            AE(nE, 4) = 1;         
          elseif  prn(i) > 263 && prn(i) < 283
            nC++;
            AC(nC, 1) = sind(Azi)*cosd(Ele);
            AC(nC, 2) = cosd(Azi)*cosd(Ele);
            AC(nC, 3) = sind(Ele);
            AC(nC, 4) = 1;         
          endif  
        endif
      endfor
      
      #GPS
      QG = inv(AG'*AG);
      PDOP_G = sqrt(QG(1,1)+QG(2,2)+QG(3,3));
      
      #GPS+Glonass
      AGR = [AG' AR'];
      AGR = AGR';
      QGR = inv(AGR'*AGR);
      PDOP_GR = sqrt(QGR(1,1)+QGR(2,2)+QGR(3,3));

      #GPS+Glonass+Galileo
      AGRE = [AG' AR' AE'];
      AGRE = AGRE';
      QGRE = inv(AGRE'*AGRE);
      PDOP_GRE = sqrt(QGRE(1,1)+QGRE(2,2)+QGRE(3,3));

      #GPS+Glonass+Galileo+Beidou
      AGREC = [AG' AR' AE' AC'];
      AGREC = AGREC';
      QGREC = inv(AGREC'*AGREC);
      PDOP_GREC = sqrt(QGREC(1,1)+QGREC(2,2)+QGREC(3,3));

      date=gps2ymdhms(gps_week, sec_of_week);

      #output number of satellites
      fprintf(fid, '%d %.1f %.1f %.1f %02d:%02d:%02d %.3f %.3f %.3f %.3f \n', gps_week, sec_of_week, rad2deg(lat), rad2deg(lon), date(4), date(5), date(6), PDOP_G, PDOP_GR, PDOP_GRE, PDOP_GREC)
      
      #add 5 minutes to gps seconds
      sec_of_week = sec_of_week + dsec;
    endfor  
#    lon = lon + deg2rad(5);
#  endfor
#  lat = lat + deg2rad(5);  
#endfor
  
fprintf('%d data written\n', l*k*j);
fclose(fid);