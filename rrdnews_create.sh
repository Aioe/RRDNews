#!/bin/bash

rrdbin="/usr/bin/rrdtool"
destdir="/tmp/"

connections="$destdir/nntp-connections.rrd"
programs="$destdir/nntp-programs.rrd"
commands="$destdir/nntp-commands.rrd"
cleanfeed="$destdir/nntp-cleanfeed.rrd"
log="$destdir/nntp-log.rrd"

$rrdbin create $connections --step 60 DS:clear:GAUGE:600:0:999 DS:total:GAUGE:600:0:999 DS:ssl:GAUGE:600:0:999 RRA:AVERAGE:0.5:300:527040 RRA:LAST:0.5:1:527040
$rrdbin create $programs --step 60  DS:innfeed:GAUGE:600:0:999  DS:innd:GAUGE:600:0:999 DS:total:GAUGE:600:0:999 RRA:AVERAGE:0.5:300:527040 RRA:LAST:0.5:1:527040

$rrdbin create $commands --step 60 DS:mode:GAUGE:600:0:999 DS:xover:GAUGE:600:0:999 DS:article:GAUGE:600:0:999 DS:connect:GAUGE:600:0:999 \
  DS:post:GAUGE:600:0:999 DS:body:GAUGE:600:0:999 DS:help:GAUGE:600:0:999 DS:list:GAUGE:600:0:999 DS:newgroup:GAUGE:600:0:999 DS:head:GAUGE:600:0:999 \
  DS:last:GAUGE:600:0:999 DS:listgroup:GAUGE:600:0:999 DS:next:GAUGE:600:0:999 DS:stat:GAUGE:600:0:999 DS:xgtitle:GAUGE:600:0:999 DS:xhdr:GAUGE:600:0:999 \
  DS:xpat:GAUGE:600:0:999 \
  RRA:AVERAGE:0.5:300:527040 RRA:LAST:0.5:1:527040

$rrdbin create $cleanfeed --step 60 DS:accepted:DERIVE:600:0:99999 DS:warning:DERIVE:600:0:99999 DS:rejected:DERIVE:600:0:99999  RRA:AVERAGE:0.5:300:527040 RRA:LAST:0.5:1:527040
$rrdbin create $log --step 60 DS:total:DERIVE:600:0:99999 DS:nnrpd:DERIVE:600:0:99999 DS:other:DERIVE:600:0:99999  RRA:AVERAGE:0.5:300:527040 RRA:LAST:0.5:1:527040
