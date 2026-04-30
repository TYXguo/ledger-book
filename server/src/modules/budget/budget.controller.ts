import type { FastifyRequest, FastifyReply } from 'fastify';
import { upsertBudgetSchema } from './budget.schema';
import { budgetService } from './budget.service';

export const budgetController = {
  async upsertBudget(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const dto = upsertBudgetSchema.parse(request.body);
    const result = await budgetService.upsert(familyId, dto);
    return reply.send(result);
  },

  async getBudgetSummary(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const { month } = request.query as { month: string };
    if (!month) return reply.status(400).send({ error: 'VALIDATION_ERROR', message: 'month is required (YYYY-MM-01)' });
    const result = await budgetService.getSummary(familyId, month);
    return reply.send(result);
  },
};
