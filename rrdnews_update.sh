#!/bin/bash

rrdbin="/usr/bin/rrdtool"

destdir="/usr/system/news/getflow/spool/rrd/"

connections="$destdir/nntp-connections.rrd"
programs="$destdir/nntp-programs.rrd"
commands="$destdir/nntp-commands.rrd"
cleanfeed="$destdir/nntp-cleanfeed.rrd"
logrrd="$destdir/nntp-log.rrd"



#################################################################################

total=$(echo `ps auxf | grep nnrpd | wc -l`)
ssl=$(echo `ps auxf | grep nnrpd-ssl | wc -l`)
let clear=$total-$ssl
nntp=$(echo `netstat -tnp | grep 46.165.242.75 | grep -e "nnrpd*" | wc -l`)
news=$(echo `netstat -tnp | grep 46.165.242.91 | grep -e "nnrpd*" | wc -l`)

$rrdbin update $connections N:$clear:$total:$ssl:$nntp:$news

#######################################################################################################

innfeed=$(echo `netstat -tnp | grep innfeed | wc -l`)
innd=$(echo `netstat -tnp | grep innd | wc -l`)
let total=$innfeed+$innd

$rrdbin update $programs N:$innfeed:$innd:$total

########################################################################################################

mode=$(echo `ps auxf | grep -i MODE | wc -l`)
xover=$(echo `ps auxf | grep -i XOVER | wc -l`)
article=$(echo `ps auxf | grep -i ARTICLE | wc -l`)
connect=$(echo `ps auxf | grep -i connect | wc -l`)
post=$(echo `ps auxf | grep -i POST | wc -l`)
body=$(echo `ps auxf | grep -i BODY | wc -l`)
help=$(echo `ps auxf | grep -i HELP | wc -l`)
list=$(echo `ps auxf | grep -i LIST | wc -l`)
newgroup=$(echo `ps auxf | grep -i NEWGROUP | wc -l`)
head=$(echo `ps auxf | grep -i HEAD | wc -l`)
last=$(echo `ps auxf | grep -i LAST | wc -l`)
listgroup=$(echo `ps auxf | grep -i LISTGROUP | wc -l`)
next=$(echo `ps auxf | grep -i NEXT | wc -l`)
stat=$(echo `ps auxf | grep -i STAT | wc -l`)
xgtitle=$(echo `ps auxf | grep -i XGTITLE | wc -l`)
xhdr=$(echo `ps auxf | grep -i XHDR | wc -l`)
xpat=$(echo `ps auxf | grep -i XPAT | wc -l`)

rrdtool update $commands N:$mode:$xover:$article:$connect:$post:$body:$help:$list:$newgroup:$head:$last:$listgroup:$next:$stat:$xgtitle:$xhdr:$xpat

##########################################################################################################

accepted=$(echo `cat /var/log/news/news | grep " + " | wc -l`)
warning=$(echo `cat /var/log/news/news | grep " ? " | wc -l`)
rejected=$(echo `cat /var/log/news/news | grep " - " | wc -l`)

$rrdbin update $cleanfeed N:$accepted:$warning:$rejected

##########################################################################################################
# DS:total:DERIVE:600:0:99999 DS:nnrpd:DERIVE:600:0:99999 DS:innfeed:DERIVE:600:0:99999 DS:innd:DERIVE:600:0:99999 DS:other

totalines=$(echo `cat /var/log/news/news.notice | wc -l`)
nnrpdlines=$(echo `cat /var/log/news/news.notice | grep "nnrpd*" | wc -l`)
innfeedlines=$(echo `cat /var/log/news/news.notice | grep "innfeed" | wc -l`)
inndlines=$(echo `cat /var/log/news/news.notice | grep "innd" | wc -l`)
let otherlines=$totalines-$nnrpdlines-$innfeedlines-$inndlines

$rrdbin update $logrrd N:$totalines:$nnrpdlines:$innfeedlines:$inndlines:$otherlines

