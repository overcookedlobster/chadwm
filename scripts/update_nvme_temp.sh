#!/bin/bash
temp=$(sudo smartctl -a -d sntrealtek /dev/sda 2>/dev/null | grep -i "Temperature Sensor 1:" | head -1 | awk '{print $4}')
echo "$temp" > /tmp/nvme_temp
