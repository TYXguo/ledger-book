import { z } from 'zod';

export const createCategorySchema = z.object({
  parentId: z.string().uuid().nullable().optional(),
  name: z.string().min(1).max(64),
  type: z.enum(['income', 'expense']),
  icon: z.string().max(64).optional(),
  color: z.string().max(32).optional(),
  sortOrder: z.number().int().optional(),
});

export type CreateCategoryDto = z.infer<typeof createCategorySchema>;
