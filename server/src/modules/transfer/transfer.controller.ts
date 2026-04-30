import type { FastifyRequest, FastifyReply } from 'fastify';
import { createTransferSchema, listTransferSchema } from './transfer.schema';
import { transferService } from './transfer.service';

export const transferController = {
  async createTransfer(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const dto = createTransferSchema.parse(request.body);
    const result = await transferService.create(familyId, dto);
    return reply.status(201).send(result);
  },

  async listTransfers(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const q = listTransferSchema.parse(request.query);
    const result = await transferService.list(familyId, q);
    return reply.send(result);
  },

  async getMemberBalance(request: FastifyRequest, reply: FastifyReply) {
    const { familyId, memberId } = request.params as { familyId: string; memberId: string };
    const result = await transferService.getBalances(familyId, memberId);
    return reply.send(result);
  },
};
