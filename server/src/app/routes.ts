import type { FastifyInstance } from 'fastify';
import { authGuard } from '../common/middlewares/auth-guard';
import { authController } from '../modules/auth/auth.controller';
import { familyController } from '../modules/family/family.controller';
import { memberController } from '../modules/member/member.controller';
import { categoryController } from '../modules/category/category.controller';
import { tagController } from '../modules/tag/tag.controller';
import { transactionController } from '../modules/transaction/transaction.controller';
import { budgetController } from '../modules/budget/budget.controller';
import { statisticController } from '../modules/statistic/statistic.controller';
import { transferController } from '../modules/transfer/transfer.controller';

export const registerRoutes = async (app: FastifyInstance) => {
  app.get('/health', async () => ({ status: 'ok' }));

  // Public
  app.post('/auth/register', authController.register);
  app.post('/auth/login', authController.login);

  // Protected — scoped with authGuard so public routes are not affected
  app.register(protectedRoutes);
};

const protectedRoutes = async (app: FastifyInstance) => {
  app.addHook('onRequest', authGuard);

  // Family
  app.post('/families', familyController.createFamily);
  app.post('/families/join', familyController.joinFamily);
  app.get('/families', familyController.listFamilies);

  // Members
  app.get('/families/:familyId/members', memberController.listMembers);

  // Categories
  app.get('/families/:familyId/categories', categoryController.listCategories);
  app.post('/families/:familyId/categories', categoryController.createCategory);
  app.delete('/families/:familyId/categories/:categoryId', categoryController.deleteCategory);

  // Tags
  app.get('/families/:familyId/tags', tagController.listTags);
  app.post('/families/:familyId/tags', tagController.createTag);

  // Transactions
  app.post('/families/:familyId/transactions', transactionController.createTransaction);
  app.get('/families/:familyId/transactions', transactionController.listTransactions);

  // Budgets
  app.post('/families/:familyId/budgets', budgetController.upsertBudget);
  app.get('/families/:familyId/budgets/summary', budgetController.getBudgetSummary);

  // Statistics
  app.get('/families/:familyId/statistics/overview', statisticController.getOverview);
  app.get('/families/:familyId/statistics/category-breakdown', statisticController.getCategoryBreakdown);
  app.get('/families/:familyId/statistics/monthly-trend', statisticController.getMonthlyTrend);

  // Transfers
  app.post('/families/:familyId/transfers', transferController.createTransfer);
  app.get('/families/:familyId/transfers', transferController.listTransfers);
  app.get('/families/:familyId/members/:memberId/balance', transferController.getMemberBalance);
};
