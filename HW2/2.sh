#!/bin/bash
grep -hEs '\(WW\)' ~/.local/share/xorg/Xorg.0.log > full.log
sed -i 's/(WW)/Warning:/g' full.log
grep -hEs '\(II\)' ~/.local/share/xorg/Xorg.0.log >> full.log
sed -i 's/(II)/Information:/g' full.log
