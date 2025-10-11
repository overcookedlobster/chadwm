#!/bin/bash
temp=$(sudo smartctl -a -d sntrealtek /dev/sda 2>/dev/null | grep -i "Temperature:" | head -1 | awk '{print $2}')
echo "$temp" > /tmp/nvme_temp
