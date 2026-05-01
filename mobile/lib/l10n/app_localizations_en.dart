// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Family Ledger';

  @override
  String get loginWelcome => 'Welcome back!';

  @override
  String get loginCreateAccount => 'Create your account';

  @override
  String get loginNickname => 'Nickname';

  @override
  String get loginEmailOrPhone => 'Email or Phone';

  @override
  String get loginPassword => 'Password';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get loginNoAccount => 'No account? Register';

  @override
  String get loginHasAccount => 'Already have an account? Login';

  @override
  String get loginFillAll => 'Please fill in all fields';

  @override
  String get loginEnterNickname => 'Please enter a nickname';

  @override
  String get homeRecentTransactions => 'Recent Transactions';

  @override
  String get homeViewAll => 'View All';

  @override
  String get homeNoTransactions => 'No transactions yet, tap + to add one!';

  @override
  String get navHome => 'Home';

  @override
  String get navBills => 'Bills';

  @override
  String get navStatistics => 'Stats';

  @override
  String get navSettings => 'Settings';

  @override
  String get overview => 'Overview';

  @override
  String get details => 'Details';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get quickBudget => 'Budget';

  @override
  String get quickTransfer => 'Transfer';

  @override
  String get quickFamily => 'Family';

  @override
  String get quickBills => 'Bills';

  @override
  String get addTransaction => 'Add Transaction';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get category => 'Category';

  @override
  String get note => 'Note';

  @override
  String get noteHint => 'Add a note...';

  @override
  String get saveTransaction => 'Save Transaction';

  @override
  String get invalidAmount => 'Please enter a valid amount';

  @override
  String get selectCategory => 'Please select a category';

  @override
  String get transactionSaved => 'Transaction saved!';

  @override
  String get transactionRecords => 'Transactions';

  @override
  String get searchByNote => 'Search by note...';

  @override
  String get all => 'All';

  @override
  String get noTransactionsFound => 'No transactions found';

  @override
  String get previousPage => 'Previous';

  @override
  String get nextPage => 'Next';

  @override
  String get statistics => 'Statistics';

  @override
  String get expenseCategories => 'Expense Categories';

  @override
  String get noExpenseData => 'No expense data';

  @override
  String get monthlyTrend => 'Monthly Trend';

  @override
  String get noTrendData => 'No trend data';

  @override
  String monthSuffix(int month) {
    return '$month月';
  }

  @override
  String get budgetTitle => 'Budget';

  @override
  String get noBudgetThisMonth => 'No budget set for this month';

  @override
  String get clickToSetBudget => 'Tap + to set a budget';

  @override
  String get monthlyBudget => 'Monthly Budget';

  @override
  String get overBudget => 'Over Budget';

  @override
  String budgetSpent(String amount) {
    return 'Spent: $amount';
  }

  @override
  String budgetAmount(String amount) {
    return 'Budget: $amount';
  }

  @override
  String budgetRemaining(String amount) {
    return 'Remaining: $amount';
  }

  @override
  String budgetUsedPercent(String percent) {
    return 'Used $percent%';
  }

  @override
  String get setBudget => 'Set Budget';

  @override
  String get budgetAmountLabel => 'Budget Amount';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get transferTitle => 'Transfer';

  @override
  String get noTransfers => 'No transfer records';

  @override
  String get clickToAddTransfer => 'Tap + to record a transfer';

  @override
  String get transferDeposit => 'Deposit';

  @override
  String get transferWithdrawal => 'Withdrawal';

  @override
  String get transferLoan => 'Loan';

  @override
  String get transferRepayment => 'Repayment';

  @override
  String get recordTransfer => 'Record Transfer';

  @override
  String get amount => 'Amount';

  @override
  String get needTwoMembers => 'At least 2 members required';

  @override
  String get familyTitle => 'Family';

  @override
  String get myFamily => 'My Family';

  @override
  String get noFamily => 'No family yet, create or join one!';

  @override
  String roleLabel(String role) {
    return 'Role: $role';
  }

  @override
  String get members => 'Members';

  @override
  String get selectFamilyToViewMembers => 'Select a family to view members';

  @override
  String get createFamily => 'Create Family';

  @override
  String get familyName => 'Family Name';

  @override
  String get joinFamily => 'Join Family';

  @override
  String get inviteCode => 'Invite Code';

  @override
  String get displayName => 'Your Display Name';

  @override
  String get create => 'Create';

  @override
  String get join => 'Join';

  @override
  String get settingsGeneral => 'General';

  @override
  String get language => 'Language';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get english => 'English';

  @override
  String get currency => 'Currency';

  @override
  String get currencyCNY => 'CNY ¥';

  @override
  String get about => 'About';

  @override
  String get aboutDescription => 'A family-oriented mobile bookkeeping app.';

  @override
  String get logout => 'Logout';

  @override
  String get categoryManagement => 'Category Management';

  @override
  String get addCategory => 'Add Category';

  @override
  String get categoryName => 'Category Name';

  @override
  String get parentCategory => 'Parent Category';

  @override
  String get noParent => 'None (Top Level)';

  @override
  String get deleteCategoryConfirm => 'Delete this category?';

  @override
  String get categoryDeleted => 'Category deleted';

  @override
  String get categoryCreated => 'Category created';

  @override
  String get manageCategories => 'Manage';

  @override
  String get singleFamilyHint => 'Each account can only belong to one family';

  @override
  String get noFamilyHint => 'Create or join a family to start tracking';
}
