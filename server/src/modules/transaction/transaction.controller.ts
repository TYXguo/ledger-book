import type { FastifyRequest, FastifyReply } from 'fastify';
import { createTransactionSchema, listTransactionSchema } from './transaction.schema';
import { transactionService } from './transaction.service';

export const transactionController = {
  async createTransaction(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const dto = createTransactionSchema.parse(request.body);
    const result = await transactionService.create((request as any).userId, familyId, dto);
    return reply.status(201).send(result);
  },

  async listTransactions(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const q = listTransactionSchema.parse(request.query);
    const result = await transactionService.list(familyId, q);
    return reply.send(result);
  },
};
