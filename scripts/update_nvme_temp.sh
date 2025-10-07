#!/bin/bash
temp=$(nvme smart-log /dev/nvme0n1 2>/dev/null | grep -i temperature | head -1 | awk '{print $3}')
echo "$temp" > /tmp/nvme_temp