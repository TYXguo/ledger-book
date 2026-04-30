import 'dotenv/config';
import { createApp } from './container';

const start = async () => {
  const app = await createApp();
  const port = Number(process.env.APP_PORT || 3000);

  await app.listen({ port, host: '0.0.0.0' });
  console.log(`API server running on port ${port}`);
};

start().catch((error) => {
  console.error(error);
  process.exit(1);
});
