#!/bin/bash
#
# https://raw.githubusercontent.com/K-Ko/raspberrypi-motd/master/motd.sh
#
# Forked from https://github.com/gagle/raspberrypi-motd
#

# To change the following settings, create a file /etc/default/motd.conf
# and apply your settings

borderColor=35
headerLeafColor=32
headerRaspberryColor=31
greetingsColor=36
statsLabelColor=33
#run4root=yes # Run also for root shell, mostly from sudo

# GO

[ -f /etc/default/motd.conf ] && . /etc/default/motd.conf

uid=$(id -u)

if [ $uid -ne 0 -o "$run4root" ]; then

    function color (){
      echo "\e[$1m$2\e[0m"
    }

    function extend (){
      local str="$1"
      let spaces=${2:-60}-${#1}
      while [ $spaces -gt 0 ]; do
        str="$str "
        let spaces=spaces-1
      done
      echo "$str"
    }

    function center (){
      local str="$1"
      let spacesLeft=(78-${#1})/2
      let spacesRight=78-spacesLeft-${#1}
      while [ $spacesLeft -gt 0 ]; do
        str=" $str"
        let spacesLeft=spacesLeft-1
      done

      while [ $spacesRight -gt 0 ]; do
        str="$str "
        let spacesRight=spacesRight-1
      done

      echo "$str"
    }

    function sec2time (){
      local input=$1

      if [ $input -lt 60 ]; then
        echo "$input seconds"
      else
        ((days=input/86400))
        ((input=input%86400))
        ((hours=input/3600))
        ((input=input%3600))
        ((mins=input/60))

        local daysPlural="s"
        local hoursPlural="s"
        local minsPlural="s"

        if [ $days -eq 1 ]; then
          daysPlural=""
        fi

        if [ $hours -eq 1 ]; then
          hoursPlural=""
        fi

        if [ $mins -eq 1 ]; then
          minsPlural=""
        fi

        echo "$days day$daysPlural, $hours hour$hoursPlural, $mins minute$minsPlural"
      fi
    }

    borderLine="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    borderBar=$(color $borderColor "┃")
    borderEmptyLine="$borderBar                                                                              $borderBar"

    # Header
    header="$(color $borderColor "┏$borderLine┓")\n$borderEmptyLine\n"
    header="$header$borderBar$(color $headerLeafColor "          .~~.   .~~.                                                         ")$borderBar\n"
    header="$header$borderBar$(color $headerLeafColor "         '. \ ' ' / .'                                                        ")$borderBar\n"
    header="$header$borderBar$(color $headerRaspberryColor "          .~ .~~~..~.                      _                          _       ")$borderBar\n"
    header="$header$borderBar$(color $headerRaspberryColor "         : .~.'~'.~. :     ___ ___ ___ ___| |_ ___ ___ ___ _ _    ___|_|      ")$borderBar\n"
    header="$header$borderBar$(color $headerRaspberryColor "        ~ (   ) (   ) ~   |  _| .'|_ -| . | . | -_|  _|  _| | |  | . | |      ")$borderBar\n"
    header="$header$borderBar$(color $headerRaspberryColor "       ( : '~'.~.'~' : )  |_| |__,|___|  _|___|___|_| |_| |_  |  |  _|_|      ")$borderBar\n"
    header="$header$borderBar$(color $headerRaspberryColor "        ~ .~ (   ) ~. ~               |_|                 |___|  |_|          ")$borderBar\n"
    header="$header$borderBar$(color $headerRaspberryColor "         (  : '~' :  )                                                        ")$borderBar\n"
    header="$header$borderBar$(color $headerRaspberryColor "          '~ .~~~. ~'                                                         ")$borderBar\n"
    header="$header$borderBar$(color $headerRaspberryColor "              '~'                                                             ")$borderBar"

    echo -e "\n$header"

    echo -e "$borderBar$(color $greetingsColor "$(center "$HOSTNAME")")$borderBar\n$borderEmptyLine"
    echo -e "$borderBar$(color $greetingsColor "$(center "$(date +"%A, %d %B %Y, %T")")")$borderBar\n$borderEmptyLine"

    uptime="$(sec2time $(cut -d "." -f 1 /proc/uptime))"
    uptime="$uptime ($(date -d "@"$(grep btime /proc/stat | cut -d " " -f 2) +"%d-%m-%Y %H:%M:%S"))"
    uptime="$(extend "$uptime")"
    echo -e "$borderBar  $(color $statsLabelColor "Uptime........:") $uptime$borderBar\n$borderEmptyLine"

    memory="$(extend "$(free -m | awk 'NR==2 { printf "Total: %sMB, Used: %sMB, Free: %sMB",$2,$3,$4; }')")"
    echo -e "$borderBar  $(color $statsLabelColor "Memory........:") $memory$borderBar"

    diskspace="$(extend "$(df -h ~ | awk 'NR==2 { printf "Total: %sB, Used: %sB, Free: %sB",$2,$3,$4; }')")"
    echo -e "$borderBar  $(color $statsLabelColor "Home space....:") $diskspace$borderBar"

    load="$(extend "$(awk '{ printf "%d%% / %d%% / %d%%", $1*100, $2*100, $3*100 }' /proc/loadavg)")"
    echo -e "$borderBar  $(color $statsLabelColor "Load average..:") $load$borderBar"

    temperature="$(extend "$(/opt/vc/bin/vcgencmd measure_temp | cut -c "6-9")ºC")"
    echo -e "$borderBar  $(color $statsLabelColor "Temperature...:") $temperature$borderBar\n$borderEmptyLine"

    if [ -s /etc/profile.d/.apt-check ]; then
        packages=$(extend "$(awk 'BEGIN {FS=";"}; {printf "%d updatable, %d security updates", $1, $2}' /etc/profile.d/.apt-check)")
        echo -e "$borderBar  $(color $statsLabelColor "Packages......:") $packages$borderBar\n$borderEmptyLine"
    fi

    echo -e $(color $borderColor "┗$borderLine┛")
fi
