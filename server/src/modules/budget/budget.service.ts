import { Prisma } from '@prisma/client';
import { prisma } from '../../common/prisma/client';
import type { UpsertBudgetDto } from './budget.schema';
import { AppError } from '../../common/errors/app-error';

export const budgetService = {
  async upsert(familyId: string, dto: UpsertBudgetDto) {
    const existing = await prisma.budget.findFirst({
      where: {
        familyId,
        ownerMemberId: dto.ownerMemberId ?? null,
        categoryId: dto.categoryId ?? null,
        budgetMonth: new Date(dto.budgetMonth),
      },
    });

    if (existing) {
      return prisma.budget.update({
        where: { id: existing.id },
        data: {
          amount: new Prisma.Decimal(dto.amount),
          alertThresholdPercent: dto.alertThresholdPercent,
        },
      });
    }

    return prisma.budget.create({
      data: {
        familyId,
        ownerMemberId: dto.ownerMemberId ?? null,
        categoryId: dto.categoryId ?? null,
        budgetMonth: new Date(dto.budgetMonth),
        amount: new Prisma.Decimal(dto.amount),
        alertThresholdPercent: dto.alertThresholdPercent,
      },
    });
  },

  async getSummary(familyId: string, month: string) {
    const budgetMonth = new Date(month);
    const budgets = await prisma.budget.findMany({ where: { familyId, budgetMonth } });

    const totalBudget = budgets.reduce((s, b) => s.add(b.amount), new Prisma.Decimal(0));

    const startOfMonth = new Date(budgetMonth.getFullYear(), budgetMonth.getMonth(), 1);
    const endOfMonth = new Date(budgetMonth.getFullYear(), budgetMonth.getMonth() + 1, 0, 23, 59, 59);

    const expenseAgg = await prisma.transaction.aggregate({
      where: { familyId, type: 'expense', status: 'active', occurredAt: { gte: startOfMonth, lte: endOfMonth } },
      _sum: { amount: true },
    });

    const totalExpense = expenseAgg._sum.amount || new Prisma.Decimal(0);

    return {
      budgetMonth: month,
      totalBudget: totalBudget.toNumber(),
      totalExpense: totalExpense.toNumber(),
      remaining: totalBudget.minus(totalExpense).toNumber(),
      usagePercent: totalBudget.isZero() ? 0 : totalExpense.div(totalBudget).mul(100).toNumber(),
      budgets,
    };
  },
};
