import { prisma } from '../../common/prisma/client';

export const memberService = {
  async listByFamily(familyId: string) {
    return prisma.familyMember.findMany({
      where: { familyId, status: 'active' },
      orderBy: { createdAt: 'asc' },
    });
  },

  async getMeInFamily(userId: string, familyId: string) {
    return prisma.familyMember.findUnique({
      where: { familyId_userId: { familyId, userId } },
    });
  },
};
