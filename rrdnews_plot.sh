#!/bin/bash


rrdbin="/usr/bin/rrdtool"
width="670"
height="400"
rrddir="/usr/system/news/getflow/spool/rrd/"
pngdir="/var/www/html/news/statistics/"
coverdir="/var/www/html/news/statistics/rrdcover/"
# let logcli="--upper-limit 100 --rigid"
coverwidth=300
coverheight=200

logcli=""

##############################################################################################################

TYPE=$1

rrdfile_connections="$rrddir/nntp-connections.rrd"
rrdfile_programs="$rrddir/nntp-programs.rrd"
rrdfile_commands="$rrddir/nntp-commands.rrd"
rrdfile_articles="$rrddir/nntp-cleanfeed.rrd"
rrdfile_log="$rrddir/nntp-log.rrd"

let day=$currenttime-86400
let week=$currenttime-604800
let month=$currenttime-2678400
let year=$currenttime-31622400

currenttime=$(echo `date +%s`)

for i in 1 2 3 4 5
do

    if [ $i -eq 1 ]
    then
	file1="$pngdir/nntp-connections-day.png"
	file2="$pngdir/nntp-programs-day.png"
	file3="$pngdir/nntp-commands-day.png"
	file4="$pngdir/nntp-articles-day.png"
	file5="$pngdir/nntp-logs-day.png"

	if [ "$TYPE" != "daily" -a "$TYPE" != "all" ];
        then 
		continue
	fi

	let start=$day
    fi

    if [ $i -eq 2 ]
    then
        file1="$pngdir/nntp-connections-week.png"
	file2="$pngdir/nntp-programs-week.png"
	file3="$pngdir/nntp-commands-week.png"
	file4="$pngdir/nntp-articles-week.png"
	file5="$pngdir/nntp-logs-week.png"
        let start=$week

        if [ "$TYPE" != "weekly" -a "$TYPE" != "all"  ];
        then 
                continue
        fi
    fi

    if [ $i -eq 3 ]
    then
        file1="$pngdir/nntp-connections-month.png"
	file2="$pngdir/nntp-programs-month.png"
	file3="$pngdir/nntp-commands-month.png"
	file4="$pngdir/nntp-articles-month.png"
	file5="$pngdir/nntp-logs-month.png"
        let start=$month
        if [ "$TYPE" != "monthly" -a "$TYPE" != "all"  ];
        then 
                continue
        fi
    fi

    if [ $i -eq 4 ]
    then
        file1="$pngdir/nntp-connections-year.png"
	file2="$pngdir/nntp-programs-year.png"
	file3="$pngdir/nntp-commands-year.png"
	file4="$pngdir/nntp-articles-year.png"
	file5="$pngdir/nntp-logs-year.png"
        let start=$year
        if [ "$TYPE" != "yearly" -a "$TYPE" != "all"  ];
        then 
                continue
        fi

    fi

    if [ $i -eq 5 ]
    then
        file1="$coverdir/nntp-connections.png"
        file2="$coverdir/nntp-programs.png"
        file3="$coverdir/nntp-commands.png"
        file4="$coverdir/nntp-articles.png"
	file5="$coverdir/nntp-logs.png"
        let start=$day
	let width=$coverwidth
        let height=$coverheight
        if [ "$TYPE" != "daily" -a "$TYPE" != "all"  ];
        then 
                continue
        fi
    fi

    $rrdbin graph --start $start --width $width --height $height --vertical-label "NNRP clients" --title "Connections established by NNRP clients" $file1  \
         DEF:linea=$rrdfile_connections:total:LAST \
         DEF:lineb=$rrdfile_connections:clear:LAST \
         DEF:linec=$rrdfile_connections:ssl:LAST   \
	 DEF:lined=$rrdfile_connections:nntp:LAST  \
	 DEF:linee=$rrdfile_connections:news:LAST   \
   	 VDEF:ds0max=linea,MAXIMUM \
    	 VDEF:ds0avg=linea,AVERAGE \
	 VDEF:ds0min=linea,MINIMUM \
	 VDEF:ds0lst=linea,LAST \
         VDEF:ds1max=lineb,MAXIMUM \
         VDEF:ds1avg=lineb,AVERAGE \
	 VDEF:ds1min=lineb,MINIMUM \
         VDEF:ds1lst=lineb,LAST \
	 VDEF:ds2max=linec,MAXIMUM \
         VDEF:ds2avg=linec,AVERAGE \
         VDEF:ds2min=linec,MINIMUM \
	 VDEF:ds2lst=linec,LAST \
         VDEF:ds3max=lined,MAXIMUM \
         VDEF:ds3avg=lined,AVERAGE \
         VDEF:ds3min=lined,MINIMUM \
         VDEF:ds3lst=lined,LAST \
         VDEF:ds4max=linee,MAXIMUM \
         VDEF:ds4avg=linee,AVERAGE \
         VDEF:ds4min=linee,MINIMUM \
         VDEF:ds4lst=linee,LAST \
	 COMMENT:"       " \
	 COMMENT:"Current" \
	 COMMENT:"Maximum" \
         COMMENT:"Average" \
         COMMENT:"Minimum\l" LINE2:linea#FF0000:"Total " GPRINT:ds0lst:"%6.2lf" GPRINT:ds0max:" %6.2lf" \
    	 GPRINT:ds0avg:" %6.2lf" \
    	 GPRINT:ds0min:" %6.2lf\l" \
	 LINE2:lineb#00FF00:"Plain" \
         GPRINT:ds1lst:" %6.2lf" \
    	 GPRINT:ds1max:" %6.2lf" \
    	 GPRINT:ds1avg:" %6.2lf" \
    	 GPRINT:ds1min:" %6.2lf\l" \
	 LINE2:linec#0000FF:"SSL  " \
	 GPRINT:ds2lst:" %6.2lf" \
         GPRINT:ds2max:" %6.2lf" \
         GPRINT:ds2avg:" %6.2lf" \
         GPRINT:ds2min:" %6.2lf\l" \
         LINE2:lined#444444:"NNTP " \
         GPRINT:ds3lst:" %6.2lf" \
         GPRINT:ds3max:" %6.2lf" \
         GPRINT:ds3avg:" %6.2lf" \
         GPRINT:ds3min:" %6.2lf\l" \
         LINE2:linee#666666:"NEWS " \
         GPRINT:ds4lst:" %6.2lf" \
         GPRINT:ds4max:" %6.2lf" \
         GPRINT:ds4avg:" %6.2lf" \
         GPRINT:ds4min:" %6.2lf\l"

    $rrdbin graph --start $start  --width $width --height $height --vertical-label "Connections" --title "Connections with peers" $file2  \
         DEF:lined=$rrdfile_programs:innfeed:LAST \
         DEF:linee=$rrdfile_programs:innd:LAST \
         DEF:linef=$rrdfile_programs:total:LAST \
         VDEF:ds2max=lined,MAXIMUM \
         VDEF:ds2avg=lined,AVERAGE \
         VDEF:ds2min=lined,MINIMUM \
         VDEF:ds2lst=lined,LAST \
         VDEF:ds3max=linee,MAXIMUM \
         VDEF:ds3avg=linee,AVERAGE \
         VDEF:ds3min=linee,MINIMUM \
         VDEF:ds3lst=linee,LAST \
         VDEF:ds4max=linef,MAXIMUM \
 	 VDEF:ds4avg=linef,AVERAGE \
         VDEF:ds4min=linef,MINIMUM \
         VDEF:ds4lst=linef,LAST \
         COMMENT:"                " \
         COMMENT:"Current" \
         COMMENT:"Maximum" \
         COMMENT:"Average" \
         COMMENT:"Minimum\l" \
         LINE2:lined#00C0C0:"Outgoing feeds" \
         GPRINT:ds2lst:" %6.2lf" \
         GPRINT:ds2max:" %6.2lf" \
         GPRINT:ds2avg:" %6.2lf" \
         GPRINT:ds2min:" %6.2lf\l" \
         LINE2:linee#C000C0:"Incoming feeds" \
         GPRINT:ds3lst:" %6.2lf" \
         GPRINT:ds3max:" %6.2lf" \
         GPRINT:ds3avg:" %6.2lf" \
         GPRINT:ds3min:" %6.2lf\l" LINE2:linef#231133:"Total         " GPRINT:ds4lst:" %6.2lf" GPRINT:ds4max:" %6.2lf"  GPRINT:ds4avg:" %6.2lf" \
         GPRINT:ds4min:" %6.2lf\l" 

    $rrdbin graph --start $start  --width $width --height $height --vertical-label "Connections" --title "Commands sent to the server" $file3  \
	DEF:linea=$rrdfile_commands:connect:LAST \
        DEF:lineb=$rrdfile_commands:mode:LAST    \
        DEF:linec=$rrdfile_commands:list:LAST    \
        DEF:lined=$rrdfile_commands:xover:LAST   \
        DEF:linee=$rrdfile_commands:article:LAST \
        DEF:linef=$rrdfile_commands:post:LAST    \
        DEF:lineg=$rrdfile_commands:body:LAST    \
        DEF:lineh=$rrdfile_commands:help:LAST    \
        DEF:linei=$rrdfile_commands:newgroup:LAST \
        DEF:linel=$rrdfile_commands:head:LAST    \
        DEF:linem=$rrdfile_commands:last:LAST    \
        DEF:linen=$rrdfile_commands:listgroup:LAST  \
        DEF:lineo=$rrdfile_commands:next:LAST   \
        DEF:linep=$rrdfile_commands:stat:LAST   \
        DEF:lineq=$rrdfile_commands:xgtitle:LAST  \
        DEF:liner=$rrdfile_commands:xhdr:LAST  \
        DEF:lines=$rrdfile_commands:xpat:LAST  \
        VDEF:ds0max=linea,MAXIMUM \
        VDEF:ds0avg=linea,AVERAGE \
        VDEF:ds0min=linea,MINIMUM \
        VDEF:ds0lst=linea,LAST \
        VDEF:ds1max=lineb,MAXIMUM \
        VDEF:ds1avg=lineb,AVERAGE \
        VDEF:ds1min=lineb,MINIMUM \
        VDEF:ds1lst=lineb,LAST \
        VDEF:ds2max=linec,MAXIMUM \
        VDEF:ds2avg=linec,AVERAGE \
        VDEF:ds2min=linec,MINIMUM \
        VDEF:ds2lst=linec,LAST \
        VDEF:ds3max=lined,MAXIMUM \
        VDEF:ds3avg=lined,AVERAGE \
        VDEF:ds3min=lined,MINIMUM \
        VDEF:ds3lst=lined,LAST \
        VDEF:ds4max=linee,MAXIMUM \
        VDEF:ds4avg=linee,AVERAGE \
        VDEF:ds4min=linee,MINIMUM \
        VDEF:ds4lst=linee,LAST \
        VDEF:ds5max=linef,MAXIMUM \
        VDEF:ds5avg=linef,AVERAGE \
        VDEF:ds5min=linef,MINIMUM \
        VDEF:ds5lst=linef,LAST \
        VDEF:ds6max=lineg,MAXIMUM \
        VDEF:ds6avg=lineg,AVERAGE \
        VDEF:ds6min=lineg,MINIMUM \
        VDEF:ds6lst=lineg,LAST \
        VDEF:ds7max=lineh,MAXIMUM \
        VDEF:ds7avg=lineh,AVERAGE \
        VDEF:ds7min=lineh,MINIMUM \
        VDEF:ds7lst=lineh,LAST \
        VDEF:ds8max=linei,MAXIMUM \
        VDEF:ds8avg=linei,AVERAGE \
        VDEF:ds8min=linei,MINIMUM \
        VDEF:ds8lst=linei,LAST \
        VDEF:ds9max=linel,MAXIMUM \
        VDEF:ds9avg=linel,AVERAGE \
        VDEF:ds9min=linel,MINIMUM \
        VDEF:ds9lst=linel,LAST \
        VDEF:ds10max=linem,MAXIMUM \
        VDEF:ds10avg=linem,AVERAGE \
        VDEF:ds10min=linem,MINIMUM \
        VDEF:ds10lst=linem,LAST \
        VDEF:ds11max=linen,MAXIMUM \
        VDEF:ds11avg=linen,AVERAGE \
        VDEF:ds11min=linen,MINIMUM \
        VDEF:ds11lst=linen,LAST \
        VDEF:ds12max=lineo,MAXIMUM \
        VDEF:ds12avg=lineo,AVERAGE \
        VDEF:ds12min=lineo,MINIMUM \
        VDEF:ds12lst=lineo,LAST \
        VDEF:ds13max=linep,MAXIMUM \
        VDEF:ds13avg=linep,AVERAGE \
        VDEF:ds13min=linep,MINIMUM \
        VDEF:ds13lst=linep,LAST \
        VDEF:ds14max=lineq,MAXIMUM \
        VDEF:ds14avg=lineq,AVERAGE \
        VDEF:ds14min=lineq,MINIMUM \
        VDEF:ds14lst=lineq,LAST \
        VDEF:ds15max=liner,MAXIMUM \
        VDEF:ds15avg=liner,AVERAGE \
        VDEF:ds15min=liner,MINIMUM \
        VDEF:ds15lst=liner,LAST \
        VDEF:ds16max=lines,MAXIMUM \
        VDEF:ds16avg=lines,AVERAGE \
        VDEF:ds16min=lines,MINIMUM \
        VDEF:ds16lst=lines,LAST \
        COMMENT:"           " \
        COMMENT:"Current" \
        COMMENT:"Maximum" \
        COMMENT:"Average" \
        COMMENT:"Minimum\l" \
        LINE1:linea#C000C0:"Connect  " GPRINT:ds0lst:" %6.2lf" GPRINT:ds0max:" %6.2lf" GPRINT:ds0avg:" %6.2lf" GPRINT:ds0min:" %6.2lf\l" \
        LINE1:lineb#00FF00:"MODE     " GPRINT:ds1lst:" %6.2lf" GPRINT:ds1max:" %6.2lf" GPRINT:ds1avg:" %6.2lf" GPRINT:ds1min:" %6.2lf\l" \
        LINE1:linec#457809:"LIST     " GPRINT:ds2lst:" %6.2lf" GPRINT:ds2max:" %6.2lf" GPRINT:ds2avg:" %6.2lf" GPRINT:ds2min:" %6.2lf\l" \
        LINE1:lined#0000FF:"XOVER    " GPRINT:ds3lst:" %6.2lf" GPRINT:ds3max:" %6.2lf" GPRINT:ds3avg:" %6.2lf" GPRINT:ds3min:" %6.2lf\l" \
        LINE1:linee#F47600:"ARTICLE  " GPRINT:ds4lst:" %6.2lf" GPRINT:ds4max:" %6.2lf" GPRINT:ds4avg:" %6.2lf" GPRINT:ds4min:" %6.2lf\l" \
        LINE1:linef#00F176:"POST     " GPRINT:ds5lst:" %6.2lf" GPRINT:ds5max:" %6.2lf" GPRINT:ds5avg:" %6.2lf" GPRINT:ds5min:" %6.2lf\l" \
        LINE1:lineg#FF66AA:"BODY     " GPRINT:ds6lst:" %6.2lf" GPRINT:ds6max:" %6.2lf" GPRINT:ds6avg:" %6.2lf" GPRINT:ds6min:" %6.2lf\l" \
        LINE1:lineh#004400:"HELP     " GPRINT:ds7lst:" %6.2lf" GPRINT:ds7max:" %6.2lf" GPRINT:ds7avg:" %6.2lf" GPRINT:ds7min:" %6.2lf\l" \
        LINE1:linei#873490:"NEWGROUPS" GPRINT:ds8lst:" %6.2lf" GPRINT:ds8max:" %6.2lf" GPRINT:ds8avg:" %6.2lf" GPRINT:ds8min:" %6.2lf\l" \
        LINE1:linel#CC7709:"HEAD     " GPRINT:ds9lst:" %6.2lf" GPRINT:ds9max:" %6.2lf" GPRINT:ds9avg:" %6.2lf" GPRINT:ds9min:" %6.2lf\l" \
        LINE1:linem#0066AA:"LAST     " GPRINT:ds10lst:" %6.2lf" GPRINT:ds10max:" %6.2lf" GPRINT:ds10avg:" %6.2lf" GPRINT:ds10min:" %6.2lf\l" \
        LINE1:linen#F0F0F0:"LISTGROUP" GPRINT:ds11lst:" %6.2lf" GPRINT:ds11max:" %6.2lf" GPRINT:ds11avg:" %6.2lf" GPRINT:ds11min:" %6.2lf\l" \
        LINE1:lineo#115500:"NEXT     " GPRINT:ds12lst:" %6.2lf" GPRINT:ds12max:" %6.2lf" GPRINT:ds12avg:" %6.2lf" GPRINT:ds12min:" %6.2lf\l" \
        LINE1:linep#ABABAB:"STAT     " GPRINT:ds13lst:" %6.2lf" GPRINT:ds13max:" %6.2lf" GPRINT:ds13avg:" %6.2lf" GPRINT:ds13min:" %6.2lf\l" \
        LINE1:lineq#110099:"XGTITLE  " GPRINT:ds14lst:" %6.2lf" GPRINT:ds14max:" %6.2lf" GPRINT:ds14avg:" %6.2lf" GPRINT:ds14min:" %6.2lf\l" \
        LINE1:liner#147722:"XHDR     " GPRINT:ds15lst:" %6.2lf" GPRINT:ds15max:" %6.2lf" GPRINT:ds15avg:" %6.2lf" GPRINT:ds15min:" %6.2lf\l" \
        LINE1:lines#990099:"XPAT     " GPRINT:ds16lst:" %6.2lf" GPRINT:ds16max:" %6.2lf" GPRINT:ds16avg:" %6.2lf" GPRINT:ds16min:" %6.2lf\l"


$rrdbin graph --start $start --width $width --height $height --vertical-label "Articles per second" --title "Articles received by this server per status" $file4 \
	 DEF:linea=$rrdfile_articles:accepted:LAST \
         DEF:lineb=$rrdfile_articles:warning:LAST \
         DEF:linec=$rrdfile_articles:rejected:LAST   \
         VDEF:ds0max=linea,MAXIMUM \
         VDEF:ds0avg=linea,AVERAGE \
         VDEF:ds0min=linea,MINIMUM \
         VDEF:ds0lst=linea,LAST \
         VDEF:ds1max=lineb,MAXIMUM \
         VDEF:ds1avg=lineb,AVERAGE \
         VDEF:ds1min=lineb,MINIMUM \
         VDEF:ds1lst=lineb,LAST \
         VDEF:ds2max=linec,MAXIMUM \
         VDEF:ds2avg=linec,AVERAGE \
         VDEF:ds2min=linec,MINIMUM \
         VDEF:ds2lst=linec,LAST \
         COMMENT:"             " \
         COMMENT:"Current" \
         COMMENT:"Maximum" \
         COMMENT:"Average" \
         COMMENT:"Minimum\l" \
         LINE1:linea#0000FF:"Accepted   " \
	 GPRINT:ds0lst:"%6.2lf" \
	 GPRINT:ds0max:" %6.2lf" \
         GPRINT:ds0avg:" %6.2lf" \
         GPRINT:ds0min:" %6.2lf\l" \
         LINE1:lineb#00FF00:"Warning   " \
         GPRINT:ds1lst:" %6.2lf" \
         GPRINT:ds1max:" %6.2lf" \
         GPRINT:ds1avg:" %6.2lf" \
         GPRINT:ds1min:" %6.2lf\l" \
 	 LINE1:linec#FF0000:"Rejected  " \
         GPRINT:ds2lst:" %6.2lf" \
         GPRINT:ds2max:" %6.2lf" \
         GPRINT:ds2avg:" %6.2lf" \
         GPRINT:ds2min:" %6.2lf\l" 


$rrdbin graph --start $start --width $width --height $height --vertical-label "Log lines per second" $logcli --title "Log lines per protocol" $file5 \
         DEF:linea=$rrdfile_log:total:LAST \
         DEF:lineb=$rrdfile_log:nnrpd:LAST  \
         DEF:linec=$rrdfile_log:innfeed:LAST \
	 DEF:lined=$rrdfile_log:innd:LAST \
	 DEF:linee=$rrdfile_log:other:LAST \
         VDEF:ds0max=linea,MAXIMUM \
         VDEF:ds0avg=linea,AVERAGE \
         VDEF:ds0min=linea,MINIMUM \
         VDEF:ds0lst=linea,LAST \
         VDEF:ds1max=lineb,MAXIMUM \
         VDEF:ds1avg=lineb,AVERAGE \
         VDEF:ds1min=lineb,MINIMUM \
         VDEF:ds1lst=lineb,LAST \
         VDEF:ds2max=linec,MAXIMUM \
         VDEF:ds2avg=linec,AVERAGE \
         VDEF:ds2min=linec,MINIMUM \
         VDEF:ds2lst=linec,LAST \
         VDEF:ds3max=lined,MAXIMUM \
         VDEF:ds3avg=lined,AVERAGE \
         VDEF:ds3min=lined,MINIMUM \
         VDEF:ds3lst=lined,LAST \
         VDEF:ds4max=linee,MAXIMUM \
         VDEF:ds4avg=linee,AVERAGE \
         VDEF:ds4min=linee,MINIMUM \
         VDEF:ds4lst=linee,LAST \
         COMMENT:"             " \
         COMMENT:"Current" \
         COMMENT:"Maximum" \
         COMMENT:"Average" \
         COMMENT:"Minimum\l" \
         LINE1:linea#0000FF:"Total       " \
         GPRINT:ds0lst:"%6.2lf" \
         GPRINT:ds0max:" %6.2lf" \
         GPRINT:ds0avg:" %6.2lf" \
         GPRINT:ds0min:" %6.2lf\l" \
         LINE1:lineb#00FF00:"NNRP       " \
         GPRINT:ds1lst:" %6.2lf" \
         GPRINT:ds1max:" %6.2lf" \
         GPRINT:ds1avg:" %6.2lf" \
         GPRINT:ds1min:" %6.2lf\l" \
	 LINE1:linec#FF6666:"innfeed    " \
         GPRINT:ds2lst:" %6.2lf" \
         GPRINT:ds2max:" %6.2lf" \
         GPRINT:ds2avg:" %6.2lf" \
         GPRINT:ds2min:" %6.2lf\l" \
         LINE1:lined#FF3300:"innd       " \
         GPRINT:ds3lst:" %6.2lf" \
         GPRINT:ds3max:" %6.2lf" \
         GPRINT:ds3avg:" %6.2lf" \
         GPRINT:ds3min:" %6.2lf\l" \
         LINE1:linee#FF0066:"Other      " \
         GPRINT:ds4lst:" %6.2lf" \
         GPRINT:ds4max:" %6.2lf" \
         GPRINT:ds4avg:" %6.2lf" \
         GPRINT:ds4min:" %6.2lf\l"


done

