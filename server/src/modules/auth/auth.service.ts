import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { prisma } from '../../common/prisma/client';
import { config } from '../../common/config';
import { AppError } from '../../common/errors/app-error';
import type { RegisterDto, LoginDto } from './auth.schema';

const SALT_ROUNDS = 10;

export const authService = {
  async register(dto: RegisterDto) {
    const existing = await prisma.appUser.findFirst({
      where: { OR: [{ email: dto.email }, { phone: dto.phone }].filter(Boolean) as any },
    });

    if (existing) throw new AppError('User already exists', 409, 'USER_EXISTS');

    const passwordHash = await bcrypt.hash(dto.password, SALT_ROUNDS);
    const user = await prisma.appUser.create({
      data: {
        email: dto.email ?? null,
        phone: dto.phone ?? null,
        passwordHash,
        nickname: dto.nickname,
      },
    });

    return { user: { id: user.id, nickname: user.nickname }, token: this.issueToken(user.id) };
  },

  async login(dto: LoginDto) {
    const user = await prisma.appUser.findFirst({
      where: dto.email ? { email: dto.email } : { phone: dto.phone },
    });

    if (!user) throw new AppError('Invalid credentials', 401, 'INVALID_CREDENTIALS');

    const valid = await bcrypt.compare(dto.password, user.passwordHash);
    if (!valid) throw new AppError('Invalid credentials', 401, 'INVALID_CREDENTIALS');

    return { user: { id: user.id, nickname: user.nickname }, token: this.issueToken(user.id) };
  },

  issueToken(userId: string) {
    return jwt.sign({ userId }, config.jwtSecret, { expiresIn: '30d' });
  },
};
