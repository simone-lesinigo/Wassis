#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PHARO_VM="$SCRIPT_DIR/../../../../../../pharo"
IMAGE="$SCRIPT_DIR/../../../../../../Pharo.image"

ST_FILE="solver.st"
INSTANCES=2

pids=()

cleanup () {
    for pid in "${pids[@]}"; do
        kill -9 $pid 2>/dev/null
    done
    
    exit 0   
}

trap cleanup SIGINT SIGTERM SIGHUP

for i in $(seq 1 $INSTANCES)
do
    "$PHARO_VM" --headless "$IMAGE" "$ST_FILE" > "$SCRIPT_DIR/log_$i.txt" 2>&1 &
    pid=$!
    pids+=($pid)
    echo $pid > "$SCRIPT_DIR/pid_$i.txt"
done

echo "Execution of images correctly started"
echo "Press CTRL + C to stop all the processes"

wait

exit 0

