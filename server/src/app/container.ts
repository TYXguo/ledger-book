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
  });

  app.setErrorHandler(errorHandler);
  await registerRoutes(app);

  return app;
};
