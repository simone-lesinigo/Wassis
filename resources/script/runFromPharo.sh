#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

INSTANCES="${1:-8}"
PHARO_VM="$2"
IMAGE="$3"

if [ -z "$PHARO_VM" ]; then
    PHARO_VM="$(command -v pharo)"
fi

if [ -z "$IMAGE" ]; then
    IMAGE="$(ls "$SCRIPT_DIR/../../../../../.."/*.image 2>/dev/null | head -n 1)"
fi

ST_FILE="$SCRIPT_DIR/solver.st"

pids=()

cleanup () {
    for pid in "${pids[@]}"; do
        kill -9 "$pid" 2>/dev/null
    done
    wait 2>/dev/null
    exit 0   
}

trap cleanup SIGINT SIGTERM SIGHUP

mkdir -p "$SCRIPT_DIR/../log"

for i in $(seq 1 "$INSTANCES")
do
    log_file="$SCRIPT_DIR/../log/log_$i.txt"
    (
        echo "BASHPID: $BASHPID"
        export WASSIS_INSTANCES="$INSTANCES"
        exec "$PHARO_VM" "$IMAGE" "$ST_FILE"
    ) > "$log_file" 2>&1 &
    
    pid=$!
    pids+=($pid)
done

echo "Esecuzione avviata con VM: $PHARO_VM"
echo "Immagine target: $IMAGE"

for pid in "${pids[@]}"; do
    wait "$pid"
done

exit 0