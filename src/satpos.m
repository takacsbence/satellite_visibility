function xsat = satpos(gps_week, sec_of_week, i, prn, health, ecc, ax, raw, aop, man, toa, inc, rra, week);

Wedot = 7.2921151467e-5;	#WGS 84 value of earth's rotation rate
mu =  3.986005e+14;		#WGS 84 value of earth's univ. grav. par.
#mean motion
			n = sqrt(mu / ax(i)^3);
			T = 2.0 * pi / n;
			dt = sec_of_week - toa(i) + (gps_week - week(i)) * 604800;
      %fprintf('sec_of_week %.3f\n', sec_of_week);
      if abs(dt) > 604800
        fprintf('*** to much time difference %f\n', dt);
      endif
			M = man(i) + n * dt;
      fprintf('n %.8f\n', n);
      
      fprintf('M %.8f\n', M);

#Kepler equation
			E = M;
			Eold = 0.0;
			j = 0;
			while (abs(E - Eold) > 1.0e-8)
				Eold = E;
				E = M + ecc(i) * sin(E);
				j++;
			endwhile
      fprintf('E %.8f\n', E);

#true anomaly
			snu = sqrt(1.0-ecc(i)^2)*sin(E);
			cnu = cos(E)-ecc(i);
			nu = atan2(snu, cnu);
      fprintf('nu %.8f\n', nu);

#position in orbit plane
			u = nu+aop(i);
			r = ax(i)*(1.0-ecc(i)*cos(E));
			wc = raw(i)+(rra(i)-Wedot)*dt-toa(i)*Wedot;
      fprintf('u %.8f\n', u);
      fprintf('r %.3f\n', r);
      fprintf('wc %.8f\n', wc);

			xdash = r*cos(u);
			ydash = r*sin(u);
			fprintf("xdash %.3f %.3f\n", xdash, ydash);

#position in ECEF system
			xsat(1) = xdash*cos(wc) - ydash*cos(inc(i))*sin(wc);
			xsat(2) = xdash*sin(wc) + ydash*cos(inc(i))*cos(wc);
			xsat(3) = ydash*sin(inc(i));
			fprintf("xsat %.3f %.3f %.3f\n", xsat(1), xsat(2), xsat(3));
      
endfunction