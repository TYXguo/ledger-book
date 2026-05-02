import { prisma } from '../../common/prisma/client';
import { AppError } from '../../common/errors/app-error';
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

  async delete(_userId: string, familyId: string, categoryId: string) {
    const root = await prisma.category.findFirst({
      where: { id: categoryId, familyId, status: 'active' },
    });
    if (!root) throw new AppError('Category not found', 404, 'NOT_FOUND');
    if (root.isSystem) throw new AppError('Cannot delete system category', 400, 'SYSTEM_CATEGORY');

    const ids: string[] = [categoryId];
    for (let i = 0; i < ids.length; i++) {
      const parentId = ids[i];
      const children = await prisma.category.findMany({
        where: { familyId, parentId, status: 'active' },
        select: { id: true },
      });
      for (const c of children) {
        if (!ids.includes(c.id)) ids.push(c.id);
      }
    }

    await prisma.category.updateMany({
      where: { id: { in: ids }, familyId },
      data: { status: 'deleted' },
    });
  },
};
