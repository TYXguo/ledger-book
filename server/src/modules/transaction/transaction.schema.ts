import { z } from 'zod';

export const createTransactionSchema = z.object({
  ownerMemberId: z.string().uuid(),
  type: z.enum(['income', 'expense', 'transfer']),
  amount: z.number().positive(),
  currency: z.string().default('CNY'),
  categoryId: z.string().uuid(),
  subCategoryId: z.string().uuid().nullable().optional(),
  occurredAt: z.string().datetime(),
  note: z.string().max(2000).optional(),
  tagIds: z.array(z.string().uuid()).optional(),
  isExcludedFromStatistics: z.boolean().optional(),
});

export const listTransactionSchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  pageSize: z.coerce.number().int().min(1).max(100).default(20),
  type: z.enum(['income', 'expense', 'transfer']).optional(),
  categoryId: z.string().uuid().optional(),
  ownerMemberId: z.string().uuid().optional(),
  keyword: z.string().optional(),
  from: z.string().datetime().optional(),
  to: z.string().datetime().optional(),
});

export type CreateTransactionDto = z.infer<typeof createTransactionSchema>;
export type ListTransactionQuery = z.infer<typeof listTransactionSchema>;
