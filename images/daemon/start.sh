#!/bin/sh

# Start the yagna daemon and put it in the background
# Using `-v yagna_datadir:/root/.local/share/yagna`
# will persist yagna datadir between containers
echo "Starting yagna daemon.."
yagna service run &
sleep 20

get_appkey () {
    echo $(yagna app-key list --json | jq -r .[0].key)
}

get_keystore_address () {
    echo $(cat $keystore_path | grep address)
}

if [ -z $(get_appkey) ]
then
    echo "Problem initializing requestor, check permissions.."
    exit 1
elif [ $(get_appkey) = "null" ]
    if [ -f "/mnt/secrets/yagna_keystore.json" ]
    then
        yagna id create --from-keystore $keystore_path
        yagna id update --set-default $(get_keystore_address)
        # kill yagna daemon
        rm /root/.local/share/yagna/accounts.json
        yagna service run &
        # make new appkey? only if used with test before
    else
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
yagna payment init --sender

sleep infinity