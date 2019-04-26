#!/bin/bash
set -ex

az=$(which az 2>/dev/null || true)
if [ -z "$az" ]; then
  az=az.cmd
fi

if [ -z "$AZURE_SUBSCRIPTION" ]; then
  AZURE_SUBSCRIPTION=$($az account show --query id -o tsv)
fi

if [ -z "$AZURE_KEYVAULT_NAME" ]; then
  echo >&2  Azure Keyvault name was not specified.
  exit 1
fi


# TODO: Check role that como.yaml has required (hard-coding to 'reader-writer' for now)
USER_ROLE=reader-writer

# Secret key convention = "named-dependency_user-role". For example: user-data_reader-writer
# user-data-server 
# user-data-database 
# user-data-reader-writer-username
# user-data-reader-writer-password
# CONNECTION_STRING=$($az keyvault secret show \
#   --subscription $AZURE_SUBSCRIPTION --vault-name $AZURE_KEYVAULT_NAME \
#   --name $COMO_NAME-$USER_ROLE \
#   --query value -o tsv)

SERVER=$($az keyvault secret show \
  --subscription $AZURE_SUBSCRIPTION --vault-name $AZURE_KEYVAULT_NAME \
  --name $COMO_NAME-server \
  --query value -o tsv)

DATABASE=$($az keyvault secret show \
  --subscription $AZURE_SUBSCRIPTION --vault-name $AZURE_KEYVAULT_NAME \
  --name $COMO_NAME-database \
  --query value -o tsv)

USERNAME=$($az keyvault secret show \
  --subscription $AZURE_SUBSCRIPTION --vault-name $AZURE_KEYVAULT_NAME \
  --name $COMO_NAME-$USER_ROLE-username \
  --query value -o tsv)

PASSWORD=$($az keyvault secret show \
  --subscription $AZURE_SUBSCRIPTION --vault-name $AZURE_KEYVAULT_NAME \
  --name $COMO_NAME-$USER_ROLE-password \
  --query value -o tsv)

echo '{"connectionString":"'"$CONNECTION_STRING"'", "server":"'"$SERVER"'", "database":"'"$DATABASE"'", "username":"'"$USERNAME"'", "password":"'"$PASSWORD"'"}'
