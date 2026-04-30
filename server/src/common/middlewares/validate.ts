import type { FastifyRequest, FastifyReply } from 'fastify';
import { ZodSchema, ZodError } from 'zod';

export const validateBody = (schema: ZodSchema) => async (request: FastifyRequest, reply: FastifyReply) => {
  try {
    request.body = schema.parse(request.body);
  } catch (err) {
    if (err instanceof ZodError) {
      return reply.status(400).send({ error: 'VALIDATION_ERROR', message: err.errors.map(e => e.message).join('; ') });
    }
    throw err;
  }
};

export const validateQuery = (schema: ZodSchema) => async (request: FastifyRequest, _reply: FastifyReply) => {
  try {
    (request as any).validatedQuery = schema.parse(request.query);
  } catch (err) {
    if (err instanceof ZodError) {
      return (request as any).validationError = err;
    }
  }
};
