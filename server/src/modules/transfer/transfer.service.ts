import { Prisma } from '@prisma/client';
import crypto from 'crypto';
import { prisma } from '../../common/prisma/client';
import type { CreateTransferDto, ListTransferQuery } from './transfer.schema';

export const transferService = {
  async create(familyId: string, dto: CreateTransferDto) {
    return prisma.transfer.create({
      data: {
        familyId,
        debtorMemberId: dto.debtorMemberId,
        creditorMemberId: dto.creditorMemberId,
        direction: dto.direction,
        amount: new Prisma.Decimal(dto.amount),
        currency: dto.currency,
        referenceNo: 'TXF-' + crypto.randomUUID().slice(0, 8).toUpperCase(),
        note: dto.note ?? null,
        relatedTransferId: dto.relatedTransferId ?? null,
        relatedTransactionId: dto.relatedTransactionId ?? null,
        occurredAt: new Date(dto.occurredAt),
        status: 'completed',
      },
    });
  },

  async list(familyId: string, q: ListTransferQuery) {
    const where: Prisma.TransferWhereInput = { familyId, status: 'completed' };

    if (q.memberId) {
      where.OR = [{ debtorMemberId: q.memberId }, { creditorMemberId: q.memberId }];
    }

    const [items, total] = await Promise.all([
      prisma.transfer.findMany({
        where,
        orderBy: { occurredAt: 'desc' },
        skip: (q.page - 1) * q.pageSize,
        take: q.pageSize,
      }),
      prisma.transfer.count({ where }),
    ]);

    return { items, total, page: q.page, pageSize: q.pageSize };
  },

  async getBalances(familyId: string, memberId: string) {
    const debts = await prisma.transfer.groupBy({
      by: ['debtorMemberId', 'creditorMemberId'],
      where: { familyId, status: 'completed', debtorMemberId: memberId },
      _sum: { amount: true },
    });

    const credits = await prisma.transfer.groupBy({
      by: ['debtorMemberId', 'creditorMemberId'],
      where: { familyId, status: 'completed', creditorMemberId: memberId },
      _sum: { amount: true },
    });

    const balanceMap: Record<string, number> = {};

    for (const d of debts) {
      const key = d.creditorMemberId;
      balanceMap[key] = (balanceMap[key] || 0) + (d._sum.amount?.toNumber() || 0);
    }

    for (const c of credits) {
      const key = c.debtorMemberId;
      balanceMap[key] = (balanceMap[key] || 0) - (c._sum.amount?.toNumber() || 0);
    }

    return Object.entries(balanceMap).map(([peerMemberId, balance]) => ({ peerMemberId, balance }));
  },
};
