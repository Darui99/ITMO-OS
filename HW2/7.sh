#!/bin/bash
man bash | grep -Ehos '[[:alpha:]]{4}[[:alpha:]]*' | sort -f | uniq -ci | sort -n | tail -n 3
