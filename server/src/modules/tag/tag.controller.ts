import type { FastifyRequest, FastifyReply } from 'fastify';
import { createTagSchema } from './tag.schema';
import { tagService } from './tag.service';

export const tagController = {
  async listTags(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const result = await tagService.list(familyId);
    return reply.send(result);
  },

  async createTag(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const dto = createTagSchema.parse(request.body);
    const result = await tagService.create((request as any).userId, familyId, dto);
    return reply.status(201).send(result);
  },
};
