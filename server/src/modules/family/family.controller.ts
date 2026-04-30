import type { FastifyRequest, FastifyReply } from 'fastify';
import { createFamilySchema, joinFamilySchema } from './family.schema';
import { familyService } from './family.service';

export const familyController = {
  async createFamily(request: FastifyRequest, reply: FastifyReply) {
    const dto = createFamilySchema.parse(request.body);
    const result = await familyService.create((request as any).userId, dto);
    return reply.status(201).send(result);
  },

  async joinFamily(request: FastifyRequest, reply: FastifyReply) {
    const dto = joinFamilySchema.parse(request.body);
    const result = await familyService.join((request as any).userId, dto);
    return reply.status(201).send(result);
  },

  async listFamilies(request: FastifyRequest, reply: FastifyReply) {
    const result = await familyService.listFamilies((request as any).userId);
    return reply.send(result);
  },
};
