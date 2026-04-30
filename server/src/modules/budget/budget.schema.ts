import { z } from 'zod';

export const upsertBudgetSchema = z.object({
  ownerMemberId: z.string().uuid().nullable().optional(),
  categoryId: z.string().uuid().nullable().optional(),
  budgetMonth: z.string().regex(/^\d{4}-\d{2}-01$/),
  amount: z.number().nonnegative(),
  alertThresholdPercent: z.number().int().min(1).max(200).default(100),
});

export type UpsertBudgetDto = z.infer<typeof upsertBudgetSchema>;
