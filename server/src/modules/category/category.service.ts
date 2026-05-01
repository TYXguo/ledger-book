import { prisma } from '../../common/prisma/client';
import type { CreateCategoryDto } from './category.schema';

export const categoryService = {
  async list(familyId: string) {
    return prisma.category.findMany({
      where: { familyId, status: 'active' },
      orderBy: [{ parentId: 'asc' }, { sortOrder: 'asc' }],
    });
  },

  async create(userId: string, familyId: string, dto: CreateCategoryDto) {
    return prisma.category.create({
      data: {
        familyId,
        createdByUserId: userId,
        parentId: dto.parentId ?? null,
        name: dto.name,
        type: dto.type,
        icon: dto.icon ?? null,
        color: dto.color ?? null,
        sortOrder: dto.sortOrder ?? 0,
      },
    });
  },
};
