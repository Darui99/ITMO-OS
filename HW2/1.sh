#!/bin/bash
grep -hrsEI 'ACPI' /var/log > errors.log
grep -hrsEI '^ACPI.*' /var/log > errors1.log
