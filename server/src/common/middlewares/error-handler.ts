import type { FastifyError, FastifyRequest, FastifyReply } from 'fastify';
import { AppError } from '../errors/app-error';

export const errorHandler = (error: FastifyError, _req: FastifyRequest, reply: FastifyReply) => {
  if (error instanceof AppError) {
    return reply.status(error.statusCode).send({ error: error.code, message: error.message });
  }

  const statusCode = error.statusCode || 500;
  return reply.status(statusCode).send({ error: 'INTERNAL_ERROR', message: error.message });
};
