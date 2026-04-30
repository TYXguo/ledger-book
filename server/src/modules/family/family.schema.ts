import { z } from 'zod';

export const createFamilySchema = z.object({
  name: z.string().min(1).max(128),
});

export const joinFamilySchema = z.object({
  inviteCode: z.string().min(1).max(32),
  displayName: z.string().min(1).max(64),
});

export type CreateFamilyDto = z.infer<typeof createFamilySchema>;
export type JoinFamilyDto = z.infer<typeof joinFamilySchema>;
