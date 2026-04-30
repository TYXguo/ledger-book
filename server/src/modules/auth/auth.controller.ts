import type { FastifyRequest, FastifyReply } from 'fastify';
import { registerSchema, loginSchema } from './auth.schema';
import { authService } from './auth.service';

export const authController = {
  async register(request: FastifyRequest, reply: FastifyReply) {
    const dto = registerSchema.parse(request.body);
    const result = await authService.register(dto);
    return reply.status(201).send(result);
  },

  async login(request: FastifyRequest, reply: FastifyReply) {
    const dto = loginSchema.parse(request.body);
    const result = await authService.login(dto);
    return reply.send(result);
  },
};
