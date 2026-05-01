import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/login_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/add_transaction/add_transaction_screen.dart';
import '../../features/transaction_list/transaction_list_screen.dart';
import '../../features/statistics/statistics_screen.dart';
import '../../features/budget/budget_screen.dart';
import '../../features/family/family_screen.dart';
import '../../features/transfer/transfer_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/category_management/category_management_screen.dart';
import '../../data/providers/auth_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = auth != null;
      final isOnLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !isOnLogin) return '/login';
      if (isLoggedIn && isOnLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/add', builder: (context, state) => const AddTransactionScreen()),
      GoRoute(path: '/transactions', builder: (context, state) => const TransactionListScreen()),
      GoRoute(path: '/statistics', builder: (context, state) => const StatisticsScreen()),
      GoRoute(path: '/budget', builder: (context, state) => const BudgetScreen()),
      GoRoute(path: '/family', builder: (context, state) => const FamilyScreen()),
      GoRoute(path: '/transfer', builder: (context, state) => const TransferScreen()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      GoRoute(path: '/categories', builder: (context, state) => const CategoryManagementScreen()),
    ],
  );
});
