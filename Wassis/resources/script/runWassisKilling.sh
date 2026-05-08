#!/opt/homebrew/bin/bash

PHARO_VM="/Users/Simo/Documents/Pharo/vms/130-x64/Pharo.app/Contents/MacOS/Pharo"
IMAGE="/Users/Simo/Documents/Pharo/images/testScript/testScript.image"
ST_FILE="solverKilling.st"
PIPE="/Users/Simo/Desktop/Wassis/script/signal"
INSTANCES=10

rm -f "$PIPE"
mkfifo "$PIPE"

pids=()

cleanup () {
    for pid in "${pids[@]}"; do
        kill -9 $pid 2>/dev/null
    done
    
    rm -f "$PIPE"
    exit 0   
}

trap cleanup SIGINT SIGTERM SIGHUP

echo "Execution started"

for i in $(seq 1 $INSTANCES)
do
    "$PHARO_VM"  --headless "$IMAGE" "$ST_FILE" &
    pids+=($!)
done

read winner_pid < "$PIPE"

echo "Winner found"

for pid in "${pids[@]}"; do
    if [ "$pid" != "$winner_pid" ]; then
        kill -9 $pid 2>/dev/null
    fi
done

wait $winner_pid

rm -f "$PIPE"

"$PHARO_VM" "$IMAGE" &

exit 0