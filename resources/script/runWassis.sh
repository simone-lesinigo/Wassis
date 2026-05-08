#!/opt/homebrew/bin/bash

PHARO_VM="/Users/Simo/Documents/Pharo/vms/130-x64/Pharo.app/Contents/MacOS/Pharo"
IMAGE="/Users/Simo/Documents/Pharo/images/WassisImage/WassisImage.image"
ST_FILE="solver.st"
INSTANCES=10

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
    "$PHARO_VM"  --headless "$IMAGE" "$ST_FILE" &
    pids+=($!)
done

echo "Execution of images correctly started"
echo "Press CTRL + C to stop all the processes"

wait

exit 0

