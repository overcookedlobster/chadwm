#!/bin/bash
temp=$(sudo smartctl -a -d sntrealtek /dev/sda 2>/dev/null | grep "Temperature Sensor 2:" | awk '{print $4}')
echo "$temp" > /tmp/nvme_dram_temp

