import Fastify from 'fastify';
import cors from '@fastify/cors';
import { registerRoutes } from './routes';
import { errorHandler } from '../common/middlewares/error-handler';

export const createApp = async () => {
  const app = Fastify({
    logger: true,
  });

  await app.register(cors, {
    origin: true,
    credentials: true,
    // Default is GET,HEAD,POST only; without DELETE (and PUT/PATCH) preflight fails on web clients.
    methods: ['GET', 'HEAD', 'PUT', 'POST', 'DELETE', 'PATCH', 'OPTIONS'],
  });

  app.setErrorHandler(errorHandler);
  await registerRoutes(app);

  return app;
};
