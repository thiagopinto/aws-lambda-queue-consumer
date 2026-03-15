import { SQSEvent, SQSRecord } from "aws-lambda";

export const handler = async (event: SQSEvent) => {
  console.log(`Recebidas ${event.Records.length} mensagens`);

  for (const record of event.Records) {
    processMessage(record);
  }

  return {
    statusCode: 200,
    body: JSON.stringify({ message: "Mensagens processadas com sucesso!" }),
  };
};

function processMessage(record: SQSRecord) {
  // Cada mensagem da fila FIFO vem com um MessageGroupId
  console.log("MessageId:", record.messageId);
  console.log("GroupId:", record.attributes.MessageGroupId);
  console.log("Body:", record.body);

  // Aqui você coloca sua lógica de negócio:
  // - salvar em banco
  // - chamar outro serviço
  // - validar dados
}
