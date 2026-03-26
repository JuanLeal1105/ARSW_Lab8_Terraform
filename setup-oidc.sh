#!/bin/bash

ORG="Usuario-git"  #Cambia esto por tu organización o usuario de GitHub
REPO="Nombre-del-repositorio"  #Cambia esto por el nombre de tu repositorio

echo "Configurando OIDC para $ORG/$REPO..."

SUB=$(az account show --query id -o tsv)
TENANT=$(az account show --query tenantId -o tsv)

APP_ID=$(az ad app create --display-name "github-lab8-oidc" --query appId -o tsv)
SP_ID=$(az ad sp create --id $APP_ID --query id -o tsv)

az role assignment create \
  --role "Contributor" \
  --assignee $APP_ID \
  --scope "/subscriptions/$SUB"

az ad app federated-credential create --id $APP_ID --parameters "{
  \"name\": \"github-main\",
  \"issuer\": \"https://token.actions.githubusercontent.com\",
  \"subject\": \"repo:${ORG}/${REPO}:ref:refs/heads/main\",
  \"audiences\": [\"api://AzureADTokenExchange\"]
}"

az ad app federated-credential create --id $APP_ID --parameters "{
  \"name\": \"github-pr\",
  \"issuer\": \"https://token.actions.githubusercontent.com\",
  \"subject\": \"repo:${ORG}/${REPO}:pull_request\",
  \"audiences\": [\"api://AzureADTokenExchange\"]
}"

az ad app federated-credential create --id $APP_ID --parameters "{
  \"name\": \"github-dispatch\",
  \"issuer\": \"https://token.actions.githubusercontent.com\",
  \"subject\": \"repo:${ORG}/${REPO}:ref:refs/heads/main\",
  \"audiences\": [\"api://AzureADTokenExchange\"]
}"

echo ""
echo "=========================================================="
echo "¡CONFIGURACIÓN EXITOSA! GUARDA ESTOS DATOS PARA GITHUB:"
echo "AZURE_CLIENT_ID:       $APP_ID"
echo "AZURE_TENANT_ID:       $TENANT"
echo "AZURE_SUBSCRIPTION_ID: $SUB"
echo "=========================================================="