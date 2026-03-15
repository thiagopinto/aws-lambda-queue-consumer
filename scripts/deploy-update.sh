#!/bin/bash
set -e

FUNCTION_NAME="aws-lambda-queue-consumer"
REGION="us-east-1"
ROLE_ARN="arn:aws:iam::900075695523:role/lambda-sqs-role"

echo "🔧 Compilando código TypeScript..."
pnpm install
pnpm build

echo "🧹 Limpando node_modules..."
rm -rf node_modules

echo "📦 Instalando apenas dependências de produção..."
pnpm install --prod

echo "📦 Empacotando Lambda..."
zip -r function.zip dist node_modules

echo "🚀 Fazendo deploy da Lambda..."
aws lambda update-function-code \
  --function-name $FUNCTION_NAME \
  --zip-file fileb://function.zip \
  --region $REGION

echo "📦 Restaurando dependências completas para desenvolvimento..."
rm -rf node_modules
pnpm install

echo "✅ Deploy concluído!"
