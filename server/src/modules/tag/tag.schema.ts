import { z } from 'zod';

export const createTagSchema = z.object({
  name: z.string().min(1).max(64),
});

export type CreateTagDto = z.infer<typeof createTagSchema>;
