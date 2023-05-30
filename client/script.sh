#!/bin/bash

# Set the command to be executed
COMMAND="daly-bms-cli -d /dev/ttyUSB0 --all --retry 100"

# MQTT
IPADDRESS=192.168.103.222
USER=pi
PASS=bmslab

# Echo Text
PHRASE="Information Sent"

# Set Serial Number file
SERIAL_FILE="serial.txt"
# Set the serial number
if [ ! -f "$SERIAL_FILE" ]; then
  echo "Serial Number File Not Found"
  exit 1
fi
SERIAL=$(cat "$SERIAL_FILE")
echo "Serial Number: "$SERIAL

# Set the counter file
COUNTER_FILE="counter.txt"
# Set the counter
if [ ! -f "$COUNTER_FILE" ]; then
  echo 0 > "$COUNTER_FILE"
fi
COUNTER=$(cat "$COUNTER_FILE")
COUNTER=$((COUNTER + 1))
echo "$COUNTER" > "$COUNTER_FILE"

echo "Counter at: "$COUNTER

while true; do
  OUTPUT=$($COMMAND)
  mosquitto_pub -h $IPADDRESS -u $USER -P $PASS -t "daly_bms/$SERIAL/$COUNTER" -m "$OUTPUT"
  echo $PHRASE
  sleep 5
done