import type { FastifyRequest, FastifyReply } from 'fastify';
import { statisticService } from './statistic.service';

export const statisticController = {
  async getOverview(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const { ownerId } = request.query as { ownerId?: string };
    const result = await statisticService.overview(familyId, ownerId);
    return reply.send(result);
  },

  async getCategoryBreakdown(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const { month, ownerId } = request.query as { month: string; ownerId?: string };
    if (!month) return reply.status(400).send({ error: 'VALIDATION_ERROR', message: 'month is required (YYYY-MM)' });
    const result = await statisticService.categoryBreakdown(familyId, month, ownerId);
    return reply.send(result);
  },

  async getMonthlyTrend(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const { months, ownerId } = request.query as { months?: string; ownerId?: string };
    const result = await statisticService.monthlyTrend(familyId, months ? Number(months) : 12, ownerId);
    return reply.send(result);
  },
};
