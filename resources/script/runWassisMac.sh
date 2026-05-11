#!/opt/homebrew/bin/bash

PHARO_VM="/Users/Simo/Documents/Pharo/vms/130-x64/Pharo.app/Contents/MacOS/Pharo"
IMAGE="/Users/Simo/Documents/Pharo/images/testImage/testImage.image"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ST_FILE="solver.st"
INSTANCES=2

pids=()

cleanup () {
    for pid in "${pids[@]}"; do
        kill -9 "$pid" 2>/dev/null
    done
    wait 2>/dev/null
    exit 0   
}

trap cleanup SIGINT SIGTERM SIGHUP

for i in $(seq 1 $INSTANCES)
do
    log_file="$SCRIPT_DIR/../log/log_$i.txt"
    (
        echo $BASHPID
        exec "$PHARO_VM" --headless "$IMAGE" "$ST_FILE"
    ) > "$log_file" 2>&1 &
    
    pid=$!
    pids+=($pid)
done

echo "Execution of images correctly started"
echo "Press CTRL + C to stop all the processes"

for pid in "${pids[@]}"; do
    wait "$pid"
done

exit 0