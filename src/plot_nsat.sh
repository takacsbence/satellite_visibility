#!/bin/sh

gmt makecpt -Cseis -T0/44/1 -I -Z > nsat.cpt
gmt gmtset PS_MEDIA = A4
gmt gmtset FONT_TITLE 8
gmt gmtset FONT_ANNOT 4
gmt gmtset MAP_FRAME_WIDTH 2p

#GPS
gmt psxy nsat.txt -i3,2,4 -R-180/180/-85/85 -P -Jq15/0.025c -K -Ss0.3 -Cnsat.cpt > nsat.ps
gmt pscoast -R -P -J -Ba30g30 -BWSNE+t"GPS" -Wblack -Dl -K -O >> nsat.ps

#scale
gmt psscale -D10/2/4.5/0.25 -K -Cnsat.cpt -B4/:"#of satellites": -O >> nsat.ps

#GPS+Glonass
gmt psxy nsat.txt -i3,2,5 -R -Xa0.0 -Ya6.5 -O -P -J -K -Ss0.3 -Cnsat.cpt >> nsat.ps
gmt pscoast -R -Y -P -J -Ba30g30 -BWSNE+t"GPS+Glonass" -Dl -K -O -Wblack >> nsat.ps

#scale
gmt psscale -D10/8.5/4.5/0.25 -K -Cnsat.cpt -B4/:"#of satellites": -O >> nsat.ps

#GPS+Glonass+Galileo
gmt psxy nsat.txt -i3,2,6 -R -Ya13.0 -P -O -J -K -Ss0.35 -Cnsat.cpt >> nsat.ps
gmt pscoast -R -Y -P -J -Ba30g30 -BWSNE+t"GPS+Glonass+Galileo" -Wblack -Dl -K -O >> nsat.ps

#scale
gmt psscale -D10/15/4.5/0.25 -K -Cnsat.cpt -B4/:"#of satellites": -O >> nsat.ps

#GPS+Glonass+Galileo+Beidou
gmt psxy nsat.txt -i3,2,7 -R -Ya19.5 -P -O -J -K -Ss0.35 -Cnsat.cpt >> nsat.ps
gmt pscoast -R -Y -P -J -Ba30g30 -BWSNE+t"GPS+Glonass+Galileo+Beidou" -Wblack -Dl -K -O >> nsat.ps

#scale
gmt psscale -D10/21.5/4.5/0.25 -K -Cnsat.cpt -B4/:"#of satellites": -O >> nsat.ps

rm nsat.cpt
ps2pdf nsat.ps nsat.pdf
