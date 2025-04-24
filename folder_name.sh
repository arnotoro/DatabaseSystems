#!/bin/bash

for d in topic*_temp; do
  temp="$topic{d}"
  mv "$d" "$temp"
done
