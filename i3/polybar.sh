#!/usr/bin/env sh

# Terminate already running bar intances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload top &
    MONITOR=$m polybar --reload bottom &
  done
else
  polybar --reload top &
  polybar --reload bottom &
fi

# Find monitor name
#export MONITOR=$(polybar -m|tail -1|sed -e 's/:.*$//g')

# Launch polybar
#polybar top &
#polybar bottom &
