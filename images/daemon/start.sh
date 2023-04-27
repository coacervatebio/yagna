#!/bin/sh

# Start the yagna daemon and put it in the background
echo "Starting yagna daemon.."
yagna service run > /home/yagna_$(date '+%Y-%m-%d_%H:%M:%S').log 2>&1 &
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
    #check for mounted secret aka existing keystore
    if [ -n "$KEYSTORE_PATH" ] && [ -f "$KEYSTORE_PATH" ]; then
        echo ""
        echo "Found keystore at $KEYSTORE_PATH, importing.."
        KEYSTORE_ADDRESS=$(jq -r  .address $KEYSTORE_PATH)
        yagna id create --from-keystore $KEYSTORE_PATH
        echo ""
        echo "Setting imported keystore as default.."
        yagna id update --set-default 0x$KEYSTORE_ADDRESS
        echo ""
        echo "Creating app key.."
        yagna app-key create keystore-$(echo $KEYSTORE_ADDRESS | cut -c1-5)-requestor
    else #create and fund for testnet
        echo ""
        echo "No appkey found, creating requestor.."
        yagna app-key create test-requestor
        sleep 5
        echo ""
        echo "Funding.."
        yagna payment fund
        sleep 10
    fi
else
    echo ""
    echo "Found existing appkey"
fi

echo ""
echo "Requestor initialized with:"
yagna app-key list

sleep infinity
