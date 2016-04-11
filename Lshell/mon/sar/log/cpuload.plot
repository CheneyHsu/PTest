set xdata time
set format x "%H:%M:%S"
set timefmt  "%H:%M:%S"
set xlabel "time is 24"
set term png size 1024,768
set output "/var/www/html/cpuload.png"
plot "./cpuload.pl" using 1:2 title"1 min cpu load" with line,"./cpuload.pl" using 1:3 title"5 min cpu load" with line,"./cpuload.pl" using 1:4 title"15 min cpu load" with line


set xdata time
set timefmt "%H:%M:%S"
set xlabel  "time is 24"
set term png size 1024,768
set output "/var/www/html/cpuuse.png"
plot "./cpuuse.pl" using 1:2 title"user cpu useing" with line,"./cpuuse.pl" using 1:3 title"system cpu useing" with line,"./cpuuse.pl" using 1:4 title"iowait" with line

set xdata time
set timefmt "%H:%M:%S"
set xlabel  "time is 24"
set term png size 1024,768
set output "/var/www/html/network.png"
plot "./network.pl" using 1:2 title "rxpck" with line, "./network.pl" using 1:3 title "txpck" with line, "./network.pl" using 1:4 title "rxkB" with line,"./network.pl" using 1:5 title "txkB" with line

set xdata time
set timefmt "%H:%M:%S"
set xlabel  "time is 24"
set term png size 1024,768
set output "/var/www/html/mem.png"
plot "./mem.pl" using 1:2 title "memory useing" with line

set xdata time
set timefmt "%H:%M:%S"
set xlabel  "time is 24"
set term png size 1024,768
set output "/var/www/html/ioload.png"
plot "./io.pl" using 1:2 title "bread/s" with line, "./io.pl" using 1:3 title "bwrtn/s" with line
