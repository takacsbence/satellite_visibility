#!/bin/sh
gmt makecpt -Cseis -T0/6/0.25 -I -Z > pdop.cpt
gmt gmtset PS_MEDIA = A4
gmt gmtset FONT_TITLE 12
gmt gmtset FONT_ANNOT 8

#GPS
gmt psxy pdop.txt -i3,2,4 -R-180/180/-85/85 -P -Jq15/0.025c -K -Ss0.3 -Cpdop.cpt > pdop.ps
gmt pscoast -R -P -J -Ba30g30 -BWSne+t"GPS" -Wblack -Dl -K -O >> pdop.ps

#scale
gmt psscale -D11/2/4.5/0.5 -K -Cpdop.cpt -B1/:"PDOP": -O >> pdop.ps

#GPS+Glonass
gmt psxy pdop.txt -i3,2,5 -R -Xa0.0 -Ya6.5 -O -P -J -K -Ss0.3 -Cpdop.cpt >> pdop.ps
gmt pscoast -R -Y -P -J -Ba30g30 -BWsne+t"GPS+Glonass" -Dl -K -O -Wblack >> pdop.ps

#scale
gmt psscale -D11/8.5/4.5/0.5 -K -Cpdop.cpt -B1/:"PDOP": -O >> pdop.ps

#GPS+Glonass+Galileo
gmt psxy pdop.txt -i3,2,6 -R -Ya13.0 -P -O -J -K -Ss0.35 -Cpdop.cpt >> pdop.ps
gmt pscoast -R -Y -P -J -Ba30g30 -BWsne+t"GPS+Glonass+Galileo" -Wblack -Dl -K -O >> pdop.ps

#scale
gmt psscale -D11/15/4.5/0.5 -K -Cpdop.cpt -B1/:"PDOP": -O >> pdop.ps

#GPS+Glonass+Galileo+Beidou
gmt psxy pdop.txt -i3,2,7 -R -Ya19.5 -P -O -J -K -Ss0.35 -Cpdop.cpt >> pdop.ps
gmt pscoast -R -Y -P -J -Ba30g30 -BWsNe+t"GPS+Glonass+Galileo+Beidou" -Wblack -Dl -K -O >> pdop.ps

#scale
gmt psscale -D11/21.5/4.5/0.5 -K -Cpdop.cpt -B1/:"PDOP": -O >> pdop.ps

rm pdop.cpt
ps2pdf pdop.ps pdop.pdf
