#!/bin/sh

BUILDER_SELECTION="executiononly"
IMPORT_KEYS="true"
DISTRIBUTED="true"

# If the builder API is enabled, override the builder selection to signal Lodestar to always propose blinded blocks.
if [[ $BUILDER_API_ENABLED == "true" ]];
then
  BUILDER_SELECTION="builderonly"
fi

if [[ $IMPORT_KEYS == "true" ]];
then
  for f in /opt/data/validator_keys/keystore-*.json; do
    echo "Importing key ${f}"

    # Import keystore with password.
    node /usr/app/packages/cli/bin/lodestar validator import \
        --dataDir="/opt/data" \
        --network="$NETWORK" \
        --importKeystores="$f" \
        --importKeystoresPassword="${f//json/txt}"
  done
else
    node /usr/app/packages/cli/bin/lodestar validator list \
        --dataDir="/opt/data" \
        --network="$NETWORK"
fi

echo "Imported all keys"

if [[ $DISTRIBUTED == "true" ]];
then
  exec node /usr/app/packages/cli/bin/lodestar validator \
      --dataDir="/opt/data" \
      --network="$NETWORK" \
      --metrics=true \
      --metrics.address="0.0.0.0" \
      --metrics.port=5064 \
      --beaconNodes="$BEACON_NODE_ADDRESS" \
      --builder="$BUILDER_API_ENABLED" \
      --builder.selection="$BUILDER_SELECTION" \
      --distributed \
      --useProduceBlockV3=false
      
else

  exec node /usr/app/packages/cli/bin/lodestar validator \
      --dataDir="/opt/data" \
      --network="$NETWORK" \
      --metrics=true \
      --metrics.address="0.0.0.0" \
      --metrics.port=5064 \
      --beaconNodes="$BEACON_NODE_ADDRESS" \
      --builder="$BUILDER_API_ENABLED" \
      --builder.selection="$BUILDER_SELECTION" \
      --useProduceBlockV3=false \
      --suggestedFeeRecipient="$FEE_RECIPIENT" \
      --graffiti="$GRAFFITI" 

fi
