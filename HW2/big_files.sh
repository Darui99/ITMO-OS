ls -Rl /var/log 2>/dev/null | grep -E '\-.*' | tr -s ' ' | cut -d ' ' -f 5 | grep -E '[[:digit:]]{4}+|[5-9][[:digit:]]{2}' | wc -l
