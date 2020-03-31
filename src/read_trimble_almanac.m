function [prn, health, ecc, ax, raw, aop, man, toa, inc, rra, week] = read_trimble_almanac(alm_file);
# read trimble almanac file
	fid = fopen(alm_file);
	if fid == -1
    fprintf('trimble almanac file could not be open!\n');
		return
  endif
  j = 0;
  prn =  health = ecc = ax = raw = aop = man = toa = inc = rra = week = [];
  while feof(fid) ~= 1
    j = j + 1;
    tline = fgetl(fid);
    prn = [prn transpose(sscanf(tline, '%d'))]; #satellite prn number 1..37 GPS, 38..64 glonass, 201..263 galileo, 264..283 beidou
    tline = fgetl(fid);
    health = [health transpose(sscanf(tline, '%x'))];  #health code
    tline = fgetl(fid);
    ecc = [ecc transpose(sscanf(tline, '%f'))];  #eccentricity
    tline = fgetl(fid);
    ax = [ax transpose(sscanf(tline, '%f'))];  #semimajor axis
    tline = fgetl(fid);
    raw = [raw transpose(sscanf(tline, '%f'))];  #right ascension of ascending node
    tline = fgetl(fid);
    aop = [aop transpose(sscanf(tline, '%f'))];  #argument of perigee
    tline = fgetl(fid);
    man = [man transpose(sscanf(tline, '%f'))];  #mean anomaly
    tline = fgetl(fid);
    toa = [toa transpose(sscanf(tline, '%f'))];  #time of almanac in GPS seconds
    tline = fgetl(fid);
    inc = [inc transpose(sscanf(tline, '%f'))];  #inclination
    tline = fgetl(fid);
    rra = [rra transpose(sscanf(tline, '%f'))];  #rate of right ascension
    tline = fgetl(fid); #satellite clock offset, not used
    tline = fgetl(fid); #satellite clock drift, not used
    tline = fgetl(fid);
    week = [week transpose(sscanf(tline, '%f'))];  #time of almanac in GPS week
    tline = fgetl(fid); #blank line

  endwhile  
  fclose(fid);
  
  ax = ax.^2;
  aop = deg2rad(aop.+0);
  raw = deg2rad(raw.+0);
  man = deg2rad(man.+0);
  inc = deg2rad(inc.+54);
  rra = deg2rad(rra./1000);

endfunction    
