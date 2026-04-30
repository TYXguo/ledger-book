import crypto from 'crypto';
import { prisma } from '../../common/prisma/client';
import { AppError } from '../../common/errors/app-error';
import type { CreateFamilyDto, JoinFamilyDto } from './family.schema';

export const familyService = {
  async create(userId: string, dto: CreateFamilyDto) {
    const inviteCode = crypto.randomBytes(8).toString('hex').toUpperCase();

    return prisma.$transaction(async (tx) => {
      const family = await tx.family.create({
        data: { name: dto.name, inviteCode, ownerUserId: userId },
      });

      await tx.familyMember.create({
        data: {
          familyId: family.id,
          userId,
          displayName: dto.name + ' Owner',
          role: 'owner',
          isDefault: true,
        },
      });

      return family;
    });
  },

  async join(userId: string, dto: JoinFamilyDto) {
    const family = await prisma.family.findUnique({ where: { inviteCode: dto.inviteCode } });
    if (!family) throw new AppError('Invalid invite code', 404, 'FAMILY_NOT_FOUND');

    const existing = await prisma.familyMember.findUnique({
      where: { familyId_userId: { familyId: family.id, userId } },
    });

    if (existing) throw new AppError('Already a member', 409, 'ALREADY_MEMBER');

    return prisma.familyMember.create({
      data: { familyId: family.id, userId, displayName: dto.displayName, role: 'member' },
    });
  },

  async listFamilies(userId: string) {
    const members = await prisma.familyMember.findMany({
      where: { userId, status: 'active' },
      include: { family: true },
    });
    return members.map((m) => ({
      familyId: m.familyId,
      name: m.family.name,
      role: m.role,
      isDefault: m.isDefault,
    }));
  },
};
