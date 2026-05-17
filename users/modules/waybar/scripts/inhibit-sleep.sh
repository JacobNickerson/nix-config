#!/usr/bin/env bash

SERVICE="waybar-inhibit.service"
TIMER_INHIBIT_FILE="/tmp/waybar-inhibitor-ps"
TIMER_DURATION_FILE="/tmp/waybar-inhibitor-duration"
TIMER_END_FILE="/tmp/waybar-inhibitor-timer"

signal_waybar() {
	pkill -SIGRTMIN+8 waybar 2>/dev/null
}

parse_duration() {
    local d="$1"

    if [[ $d =~ ^([0-9]+([.][0-9]+)?)([smhd]?)$ ]]; then
        local value="${BASH_REMATCH[1]}"
        local unit="${BASH_REMATCH[3]}"

        case "$unit" in
            ""|s) mult=1 ;;
            m) mult=60 ;;
            h) mult=3600 ;;
            d) mult=86400 ;;
        esac

        # handle decimal values
        awk -v v="$value" -v m="$mult" 'BEGIN { printf "%.0f", v*m }'
    else
        return 1
    fi
}

kill_timer() {
	TIMER_INHIBIT_PID=$(<"$TIMER_INHIBIT_FILE")
	kill $TIMER_INHIBIT_PID
	wait $TIMER_INHIBIT_PID 2>/dev/null
	rm $TIMER_INHIBIT_FILE $TIMER_END_FILE
}

status() {
	if systemctl --user is-active --quiet "$SERVICE"; then
		echo '{"alt":"inhibited","class":"inhibited","tooltip":"Sleep inhibited"}'
	elif [[ -f "$TIMER_INHIBIT_FILE" ]]; then
		echo '{"alt":"time-inhibited","class":"time-inhibited","tooltip":"Sleep inhibited until '$(<"$TIMER_END_FILE")'"}'
	else
		echo '{"alt":"uninhibited","class":"uninhibited","tooltip":"Sleep allowed"}'
	fi
}

toggle() {
	if [[ -f "$TIMER_INHIBIT_FILE" ]]; then
		kill_timer
	elif systemctl --user is-active --quiet "$SERVICE"; then
		systemctl --user stop "$SERVICE"
	else
		systemctl --user start "$SERVICE"
	fi

	signal_waybar
}

menu() {
	alacritty -e bash -c '
		while true; do
			read -rp "Sleep duration: " duration

			if [[ "$duration" =~ ^[0-9]+(\.[0-9]+)?(s|m|h|d)?$ ]]; then
			 	echo "$duration" > "'$TIMER_DURATION_FILE'"
				break
			else
				echo "Invalid duration"
			fi
		done
	' &
	wait $!
	local duration=$(<$TIMER_DURATION_FILE)
	rm $TIMER_DURATION_FILE
	if [ -z $duration ]; then
		exit 1
	fi

	if [[ -f "$TIMER_INHIBIT_FILE" ]]; then
		kill_timer
	elif systemctl --user is-active --quiet "$SERVICE"; then
		systemctl --user stop $SERVICE
	fi
	

	duration_seconds=$(parse_duration $duration)
	local end_time=$(date -d "+$duration_seconds seconds" +"%H:%M:%S")
	local end_date=$(date -d "+$duration_seconds seconds" +"%m-%d-%Y")
	if [ $end_date == $(date +"%m-%d-%Y") ]; then
		local end_time_stamp=$end_time
	else
		local end_time_stamp="$end_date $end_time"
	fi

	# Create the inhibiting process
	nohup systemd-inhibit --what=sleep:idle --why="Waybar blocking sleep until $end_time_stamp" sleep $duration  > /dev/null 2>&1 &	
	TIMER_INHIBIT_PID=$!
	echo $end_time > $TIMER_END_FILE

	# Chase it with a process that cleans up the file
	nohup bash -c "sleep $duration && rm $TIMER_INHIBIT_FILE $TIMER_END_FILE && pkill -SIGRTMIN+8 waybar" > /dev/null 2>&1 & 
	echo "$TIMER_INHIBIT_PID $!" > $TIMER_INHIBIT_FILE

	signal_waybar
}

case "$1" in
	toggle) toggle ;;
	menu) menu ;;
	*) status ;;
esac