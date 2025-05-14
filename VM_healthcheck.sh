#!/bin/bash

# Function to calculate CPU usage
check_cpu_usage() {
  cpu_usage=$(top -bn1 | grep "Cpu(s)" | \
              sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
              awk '{print 100 - $1}')
  echo $cpu_usage
}

# Function to calculate Memory usage
check_memory_usage() {
  memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
  echo $memory_usage
}

# Function to calculate Disk usage
check_disk_usage() {
  disk_usage=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
  echo $disk_usage
}

# Main logic to determine VM health
cpu=$(check_cpu_usage)
memory=$(check_memory_usage)
disk=$(check_disk_usage)

status_message="The state of the VM is: Healthy"
reason_message="All metrics are below 60% utilization."

if (( $(echo "$cpu >= 60" | bc -l) )) || (( $(echo "$memory >= 60" | bc -l) )) || (( $disk >= 60 )); then
  status_message="The state of the VM is: Not Healthy"
  reason_message=""

  if (( $(echo "$cpu >= 60" | bc -l) )); then
    reason_message+="CPU usage is above 60%. Current usage: $cpu%. "
  fi

  if (( $(echo "$memory >= 60" | bc -l) )); then
    reason_message+="Memory usage is above 60%. Current usage: $memory%. "
  fi

  if (( $disk >= 60 )); then
    reason_message+="Disk usage is above 60%. Current usage: $disk%. "
  fi
fi

# Print results
echo "CPU Usage: $cpu%"
echo "Memory Usage: $memory%"
echo "Disk Usage: $disk%"
echo "$status_message"

# If the 'explain' argument is passed, provide reasons
if [[ $1 == "explain" ]]; then
  echo "Reason: $reason_message"
fi
