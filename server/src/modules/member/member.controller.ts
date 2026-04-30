import type { FastifyRequest, FastifyReply } from 'fastify';
import { memberService } from './member.service';

export const memberController = {
  async listMembers(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const result = await memberService.listByFamily(familyId);
    return reply.send(result);
  },
};
