#!/bin/bash

# Ping google.com and capture the time it took
ping_output=$(ping -c 1 google.com 2>&1)

# Extract the time from the ping response, or set to -1 if failed
ping_time=$(echo "$ping_output" | grep 'time=' | awk -F'time=' '{print $2}' | awk '{print $1}')

# Determine if the ping was successful
if [ -z "$ping_time" ]; then
  ping_success=0
  ping_time=-1
else
  ping_success=1
fi

# Output metrics in Prometheus format
echo "# HELP probe_success Whether the ping probe was successful (1 = success, 0 = failure)"
echo "# TYPE probe_success gauge"
echo "probe_success $ping_success"

echo "# HELP probe_duration_seconds Duration of the ping probe in seconds"
echo "# TYPE probe_duration_seconds gauge"
echo "probe_duration_seconds $ping_time"
