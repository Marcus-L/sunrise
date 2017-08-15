#!/bin/bash

API='http://192.168.5.148/api/s6Mkw2cc477nLQ9wD42A5SOYJYspvKN8LQshpy5A'
JSON='Content-Type: application/json'
netcat -d localhost 1099 | while read line
do
    match=$(echo $line | grep -c -i -E 'Bright|Dim')
    if [ $match -eq 1 ]; then
        /home/pi/sunrise/scripts/stream2chromecast/stream2chromecast.py -devicename "Bedroom" -stop
    fi

    match=$(echo $line | grep -c -i -E 'A2 Func: On')
    if [ $match -eq 1 ]; then
        curl -H "$JSON" -X PUT -d '{"on": true}' $API/groups/1/action
    fi

    match=$(echo $line | grep -c -i -E 'A2 Func: Off')
    if [ $match -eq 1 ]; then
        curl -H "$JSON" -X PUT -d '{"on": false}' $API/groups/1/action
    fi
done
