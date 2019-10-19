#!/bin/bash
sudo find /var/log -name '*.log' -exec cat {} + | wc -l
