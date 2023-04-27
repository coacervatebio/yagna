#!/bin/sh

# Start the yagna daemon and put it in the background
printf "Starting yagna daemon..\n"
yagna service run > "/home/yagna_$(date '+%Y-%m-%d_%H:%M:%S').log" 2>&1 &
sleep 20

# Function to get the first app key
get_appkey () {
    echo "$(yagna app-key list --json | jq -r .[0].key)"
}

# Check if an app key is present or not
if [ -z "$(get_appkey)" ]; then
    printf "Problem initializing requestor, check permissions..\n"
    exit 1
elif [ "$(get_appkey)" = "null" ]; then
    # Check for mounted secret aka existing keystore
    if [ -n "$KEYSTORE_PATH" ] && [ -f "$KEYSTORE_PATH" ]; then
        printf "\nFound keystore at %s, importing..\n" "$KEYSTORE_PATH"
        KEYSTORE_ADDRESS=$(jq -r .address "$KEYSTORE_PATH")
        yagna id create --from-keystore "$KEYSTORE_PATH"
        printf "\nSetting imported keystore as default..\n"
        yagna id update --set-default "0x$KEYSTORE_ADDRESS"
        printf "\nCreating app key..\n"
        yagna app-key create "keystore-$(echo "$KEYSTORE_ADDRESS" | cut -c1-5)-requestor"
    else # Create and fund for testnet
        printf "\nNo appkey found, creating requestor..\n"
        yagna app-key create "test-requestor"
        sleep 5
        printf "\nFunding..\n"
        yagna payment fund
        sleep 10
    fi
else
    printf "\nFound existing appkey\n"
fi

# Print the initialized app key(s)
printf "\nRequestor initialized with:\n"
yagna app-key list

sleep infinity

