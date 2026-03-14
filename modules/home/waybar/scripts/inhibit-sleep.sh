#!/usr/bin/env bash

SERVICE="waybar-inhibit.service"
TIME_INHIBIT_FILE="/tmp/waybar-time-inhibitor"

signal_waybar() {
	pkill -SIGRTMIN+8 waybar 2>/dev/null
}

kill_timer() {
	TIME_INHIBIT_PID=$(<"$TIME_INHIBIT_FILE")
	echo $TIME_INHIBIT_PID
	kill $TIME_INHIBIT_PID
	wait $TIME_INHIBIT_PID 2>/dev/null
	rm $TIME_INHIBIT_FILE
}

status() {
	if systemctl --user is-active --quiet "$SERVICE"; then
		echo '{"alt":"inhibited","class":"inhibited","tooltip":"Sleep inhibited"}'
	elif [[ -f "$TIME_INHIBIT_FILE" ]]; then
		echo '{"alt":"time-inhibited","class":"time-inhibited","tooltip":"Sleep inhibited for 5min"}'
	else
		echo '{"alt":"uninhibited","class":"uninhibited","tooltip":"Sleep allowed"}'
	fi
}

toggle() {
	if [[ -f "$TIME_INHIBIT_FILE" ]]; then
		kill_timer
	elif systemctl --user is-active --quiet "$SERVICE"; then
		systemctl --user stop "$SERVICE"
	else
		systemctl --user start "$SERVICE"
	fi

	signal_waybar
}

menu() {
	if [[ -f "$TIME_INHIBIT_FILE" ]]; then
		kill_timer
	elif systemctl --user is-active --quiet "$SERVICE"; then
		systemctl --user stop $SERVICE
	fi
	
	while true; do
		read -rp "Sleep duration: " duration

		if [[ "$duration" =~ ^[0-9]+(\.[0-9]+)?(s|m|h|d)?$ ]]; then
			break
		else
			echo "Invalid duration"
		fi
	done


	# Create the inhibiting process
	nohup systemd-inhibit --what=sleep:idle --why='Waybar toggle' sleep $duration > /dev/null 2>&1 &	
	TIME_INHIBIT_PID=$!

	# Chase it with a process that cleans up the file
	nohup bash -c "sleep $duration && rm $TIME_INHIBIT_FILE && pkill -SIGRTMIN+8 waybar" > /dev/null 2>&1 & 
	echo "$TIME_INHIBIT_PID $!" > $TIME_INHIBIT_FILE

	signal_waybar
}

case "$1" in
	toggle) toggle ;;
	menu) menu ;;
	*) status ;;
esac