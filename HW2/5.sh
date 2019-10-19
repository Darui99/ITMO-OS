#!/bin/bash
sort -n -t : -k3 /etc/passwd | cut -d : -f 1
