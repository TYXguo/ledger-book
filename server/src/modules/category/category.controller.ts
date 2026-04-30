import type { FastifyRequest, FastifyReply } from 'fastify';
import { createCategorySchema } from './category.schema';
import { categoryService } from './category.service';

export const categoryController = {
  async listCategories(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const result = await categoryService.list(familyId);
    return reply.send(result);
  },

  async createCategory(request: FastifyRequest, reply: FastifyReply) {
    const { familyId } = request.params as { familyId: string };
    const dto = createCategorySchema.parse(request.body);
    const result = await categoryService.create((request as any).userId, familyId, dto);
    return reply.status(201).send(result);
  },
};
