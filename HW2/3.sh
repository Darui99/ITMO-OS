#!/bin/bash
grep -hErosa '[[:alnum:]]+@[[:alnum:]]+\.+[[:alnum:]]+' /etc | tr '\n' ',' > emails.lst
truncate -s-1 emails.lst
