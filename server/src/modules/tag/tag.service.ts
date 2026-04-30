import { prisma } from '../../common/prisma/client';
import type { CreateTagDto } from './tag.schema';

export const tagService = {
  async list(familyId: string) {
    return prisma.tag.findMany({ where: { familyId, status: 'active' }, orderBy: { name: 'asc' } });
  },

  async create(userId: string, familyId: string, dto: CreateTagDto) {
    return prisma.tag.create({
      data: { familyId, createdByUserId: userId, name: dto.name },
    });
  },
};
