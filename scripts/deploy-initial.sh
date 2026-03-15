#!/bin/bash
set -e

FUNCTION_NAME="aws-lambda-queue-consumer"
REGION="us-east-1"
ROLE_ARN="arn:aws:iam::900075695523:role/lambda-sqs-role"
QUEUE_ARN="arn:aws:sqs:us-east-1:900075695523:ezzepay-webhooks.fifo"
RUNTIME="nodejs22.x"

echo "🔧 Compilando código TypeScript..."
pnpm install
pnpm build

echo "🧹 Limpando node_modules..."
rm -rf node_modules

echo "📦 Instalando apenas dependências de produção..."
pnpm install --prod

echo "📦 Empacotando Lambda..."
zip -r function.zip dist node_modules

echo "🚀 Criando Lambda pela primeira vez..."
aws lambda create-function \
  --function-name $FUNCTION_NAME \
  --runtime $RUNTIME \
  --role $ROLE_ARN \
  --handler dist/handler.handler \
  --zip-file fileb://function.zip \
  --region $REGION

echo "🔗 Conectando Lambda à fila SQS..."
aws lambda create-event-source-mapping \
  --function-name $FUNCTION_NAME \
  --event-source-arn $QUEUE_ARN \
  --batch-size 10 \
  --region $REGION

echo "📦 Restaurando dependências completas para desenvolvimento..."
rm -rf node_modules
pnpm install

echo "✅ Deploy inicial concluído!"
