#!/bin/bash

for d in topic*_temp; do
  temp="${d/_temp/}"
  mv "$d" "$temp"
done
