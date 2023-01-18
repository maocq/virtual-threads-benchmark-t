#!/bin/bash

cases=("go-ms")

for case in "${cases[@]}"; do
  echo "Starting $case"
  ./start.sh "$case"
  ./performance-analyzer.sh "$case"
  ./stop.sh "$case"
done
