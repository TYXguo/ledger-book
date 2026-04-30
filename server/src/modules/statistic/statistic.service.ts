import { Prisma } from '@prisma/client';
import { prisma } from '../../common/prisma/client';
import { dayRange, weekRange, monthRange } from '../../common/utils/date-range';

export const statisticService = {
  async overview(familyId: string, ownerId?: string) {
    const now = new Date();
    const d = dayRange(now);
    const w = weekRange(now);
    const m = monthRange(now);

    const memberFilter = ownerId ? { ownerMemberId: ownerId } : {};

    const query = (from: Date, to: Date) =>
      prisma.transaction.aggregate({
        where: { familyId, status: 'active', occurredAt: { gte: from, lte: to }, ...memberFilter },
        _sum: { amount: true },
        _count: true,
      });

    const [todayExpense, todayIncome, weekExpense, weekIncome, monthExpense, monthIncome] = await Promise.all([
      query(d.from, d.to).then(r => ({ sum: r._sum.amount || new Prisma.Decimal(0), count: r._count })),
      query(d.from, d.to).then(r => ({ sum: r._sum.amount || new Prisma.Decimal(0), count: r._count })),
      query(w.from, w.to).then(r => ({ sum: r._sum.amount || new Prisma.Decimal(0), count: r._count })),
      query(w.from, w.to).then(r => ({ sum: r._sum.amount || new Prisma.Decimal(0), count: r._count })),
      query(m.from, m.to).then(r => ({ sum: r._sum.amount || new Prisma.Decimal(0), count: r._count })),
      query(m.from, m.to).then(r => ({ sum: r._sum.amount || new Prisma.Decimal(0), count: r._count })),
    ]);

    return {
      today: { expense: todayExpense.sum.toNumber(), income: todayIncome.sum.toNumber() },
      week: { expense: weekExpense.sum.toNumber(), income: weekIncome.sum.toNumber() },
      month: { expense: monthExpense.sum.toNumber(), income: monthIncome.sum.toNumber() },
    };
  },

  async categoryBreakdown(familyId: string, month: string, ownerId?: string) {
    const [yearStr, monthStr] = month.split('-');
    const from = new Date(Number(yearStr), Number(monthStr) - 1, 1);
    const to = new Date(Number(yearStr), Number(monthStr), 0, 23, 59, 59);
    const memberFilter = ownerId ? { ownerMemberId: ownerId } : {};

    const rows = await prisma.transaction.groupBy({
      by: ['categoryId', 'type'],
      where: { familyId, status: 'active', occurredAt: { gte: from, lte: to }, ...memberFilter },
      _sum: { amount: true },
      _count: true,
      orderBy: { _sum: { amount: 'desc' } },
    });

    const categoryIds = [...new Set(rows.map((r) => r.categoryId))];
    const categories = await prisma.category.findMany({ where: { id: { in: categoryIds } } });
    const catMap = Object.fromEntries(categories.map((c) => [c.id, c]));

    return rows.map((r) => ({
      categoryId: r.categoryId,
      categoryName: catMap[r.categoryId]?.name ?? 'Unknown',
      type: r.type,
      totalAmount: (r._sum.amount || new Prisma.Decimal(0)).toNumber(),
      count: r._count,
    }));
  },

  async monthlyTrend(familyId: string, months = 12, ownerId?: string) {
    const memberFilter = ownerId ? { ownerMemberId: ownerId } : {};
    const now = new Date();

    const results = await Promise.all(
      Array.from({ length: months }, (_, i) => {
        const d = new Date(now.getFullYear(), now.getMonth() - i, 1);
        const from = new Date(d.getFullYear(), d.getMonth(), 1);
        const to = new Date(d.getFullYear(), d.getMonth() + 1, 0, 23, 59, 59);
        const monthLabel = `${from.getFullYear()}-${String(from.getMonth() + 1).padStart(2, '0')}`;

        return prisma.transaction.groupBy({
          by: ['type'],
          where: { familyId, status: 'active', occurredAt: { gte: from, lte: to }, ...memberFilter },
          _sum: { amount: true },
        }).then((rows) => {
          const inc = rows.find((r) => r.type === 'income');
          const exp = rows.find((r) => r.type === 'expense');
          return {
            month: monthLabel,
            income: (inc?._sum.amount || new Prisma.Decimal(0)).toNumber(),
            expense: (exp?._sum.amount || new Prisma.Decimal(0)).toNumber(),
          };
        });
      }),
    );

    return results.reverse();
  },
};
