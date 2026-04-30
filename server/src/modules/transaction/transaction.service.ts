import { Prisma } from '@prisma/client';
import { prisma } from '../../common/prisma/client';
import type { CreateTransactionDto, ListTransactionQuery } from './transaction.schema';

export const transactionService = {
  async create(userId: string, familyId: string, dto: CreateTransactionDto) {
    return prisma.$transaction(async (tx) => {
      const txn = await tx.transaction.create({
        data: {
          familyId,
          createdByUserId: userId,
          ownerMemberId: dto.ownerMemberId,
          type: dto.type,
          amount: new Prisma.Decimal(dto.amount),
          currency: dto.currency,
          categoryId: dto.categoryId,
          subCategoryId: dto.subCategoryId ?? null,
          occurredAt: new Date(dto.occurredAt),
          note: dto.note ?? null,
          isExcludedFromStatistics: dto.isExcludedFromStatistics ?? false,
        },
      });

      if (dto.tagIds?.length) {
        await tx.transactionTag.createMany({
          data: dto.tagIds.map((tagId) => ({ transactionId: txn.id, tagId })),
        });
      }

      return txn;
    });
  },

  async list(familyId: string, q: ListTransactionQuery) {
    const where: Prisma.TransactionWhereInput = { familyId, status: 'active' };

    if (q.type) where.type = q.type;
    if (q.categoryId) where.categoryId = q.categoryId;
    if (q.ownerMemberId) where.ownerMemberId = q.ownerMemberId;
    if (q.from || q.to) {
      where.occurredAt = {};
      if (q.from) where.occurredAt.gte = new Date(q.from);
      if (q.to) where.occurredAt.lte = new Date(q.to);
    }
    if (q.keyword) {
      where.note = { contains: q.keyword, mode: 'insensitive' };
    }

    const [items, total] = await Promise.all([
      prisma.transaction.findMany({
        where,
        orderBy: { occurredAt: 'desc' },
        skip: (q.page - 1) * q.pageSize,
        take: q.pageSize,
        include: { category: true, subCategory: true, transactionTags: { include: { tag: true } } },
      }),
      prisma.transaction.count({ where }),
    ]);

    return { items, total, page: q.page, pageSize: q.pageSize };
  },
};
