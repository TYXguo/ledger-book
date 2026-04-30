import { z } from 'zod';

export const createTransferSchema = z.object({
  debtorMemberId: z.string().uuid(),
  creditorMemberId: z.string().uuid(),
  direction: z.enum(['loan', 'repayment', 'deposit', 'withdrawal', 'adjustment']),
  amount: z.number().positive(),
  currency: z.string().default('CNY'),
  note: z.string().max(2000).optional(),
  relatedTransferId: z.string().uuid().nullable().optional(),
  relatedTransactionId: z.string().uuid().nullable().optional(),
  occurredAt: z.string().datetime(),
});

export const listTransferSchema = z.object({
  page: z.coerce.number().int().min(1).default(1),
  pageSize: z.coerce.number().int().min(1).max(100).default(20),
  memberId: z.string().uuid().optional(),
});

export type CreateTransferDto = z.infer<typeof createTransferSchema>;
export type ListTransferQuery = z.infer<typeof listTransferSchema>;
