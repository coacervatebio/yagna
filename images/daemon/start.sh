#!/bin/sh

# Start the yagna daemon and put it in the background
# Using `-v yagna_datadir:/home/coacervate/.local/share/yagna`
# will persist yagna datadir between containers
echo "Starting yagna daemon.."
yagna service run &
sleep 20

get_appkey () {
    echo $(yagna app-key list --json | jq -r .[0].key)
}

if [ -z $(get_appkey) ]
then
    echo "Problem initializing requestor, check permissions.."
    exit 1
elif [ $(get_appkey) = "null" ]
then
    echo "No appkey found, creating requestor.."
    yagna app-key create requestor
    sleep 5
    echo "Funding.."
    yagna payment fund
    sleep 10
else
    echo "Found existing appkey"
fi

echo "Exporting app key and initializing yagna as sender.."
export YAGNA_APPKEY=$(get_appkey)
sleep 3
yagna payment init --sender

sleep infinity