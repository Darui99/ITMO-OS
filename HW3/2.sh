#!/bin/bash
ps -axu --sort=start_time | sed 1d | tr -s ' ' | cut -d ' ' -f 2,9 | tail -n 1 | cut -d ' ' -f 1
