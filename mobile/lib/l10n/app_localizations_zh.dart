// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '家庭账本';

  @override
  String get loginWelcome => '欢迎回来！';

  @override
  String get loginCreateAccount => '创建你的账号';

  @override
  String get loginNickname => '昵称';

  @override
  String get loginEmailOrPhone => '邮箱或手机号';

  @override
  String get loginPassword => '密码';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get loginNoAccount => '没有账号？注册';

  @override
  String get loginHasAccount => '已有账号？登录';

  @override
  String get loginFillAll => '请填写所有字段';

  @override
  String get loginEnterNickname => '请输入昵称';

  @override
  String get homeRecentTransactions => '最近交易';

  @override
  String get homeViewAll => '查看全部';

  @override
  String get homeNoTransactions => '暂无交易记录，点击 + 添加一笔！';

  @override
  String get navHome => '首页';

  @override
  String get navBills => '账单';

  @override
  String get navStatistics => '统计';

  @override
  String get navSettings => '设置';

  @override
  String get overview => '总览';

  @override
  String get details => '详情';

  @override
  String get today => '今日';

  @override
  String get thisWeek => '本周';

  @override
  String get thisMonth => '本月';

  @override
  String get quickBudget => '预算';

  @override
  String get quickTransfer => '转账';

  @override
  String get quickFamily => '家庭';

  @override
  String get quickBills => '账单';

  @override
  String get addTransaction => '添加交易';

  @override
  String get expense => '支出';

  @override
  String get income => '收入';

  @override
  String get category => '分类';

  @override
  String get note => '备注';

  @override
  String get noteHint => '添加备注...';

  @override
  String get saveTransaction => '保存交易';

  @override
  String get invalidAmount => '请输入有效的金额';

  @override
  String get selectCategory => '请选择一个分类';

  @override
  String get transactionSaved => '交易已保存！';

  @override
  String get transactionRecords => '交易记录';

  @override
  String get searchByNote => '按备注搜索...';

  @override
  String get all => '全部';

  @override
  String get noTransactionsFound => '未找到交易记录';

  @override
  String get previousPage => '上一页';

  @override
  String get nextPage => '下一页';

  @override
  String get statistics => '统计';

  @override
  String get expenseCategories => '支出分类';

  @override
  String get noExpenseData => '暂无支出数据';

  @override
  String get monthlyTrend => '月度趋势';

  @override
  String get noTrendData => '暂无趋势数据';

  @override
  String monthSuffix(int month) {
    return '$month月';
  }

  @override
  String get budgetTitle => '预算';

  @override
  String get noBudgetThisMonth => '本月暂未设置预算';

  @override
  String get clickToSetBudget => '点击 + 设置预算';

  @override
  String get monthlyBudget => '月度预算';

  @override
  String get overBudget => '超出预算';

  @override
  String budgetSpent(String amount) {
    return '已支出：$amount';
  }

  @override
  String budgetAmount(String amount) {
    return '预算：$amount';
  }

  @override
  String budgetRemaining(String amount) {
    return '剩余：$amount';
  }

  @override
  String budgetUsedPercent(String percent) {
    return '已使用 $percent%';
  }

  @override
  String get setBudget => '设置预算';

  @override
  String get budgetAmountLabel => '预算金额';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get transferTitle => '转账';

  @override
  String get noTransfers => '暂无转账记录';

  @override
  String get clickToAddTransfer => '点击 + 记录一笔转账';

  @override
  String get transferDeposit => '存入';

  @override
  String get transferWithdrawal => '取出';

  @override
  String get transferLoan => '借出';

  @override
  String get transferRepayment => '还款';

  @override
  String get recordTransfer => '记录转账';

  @override
  String get amount => '金额';

  @override
  String get needTwoMembers => '至少需要2名成员';

  @override
  String get familyTitle => '家庭';

  @override
  String get myFamily => '我的家庭';

  @override
  String get noFamily => '暂无家庭，创建或加入一个吧！';

  @override
  String roleLabel(String role) {
    return '角色：$role';
  }

  @override
  String get members => '成员';

  @override
  String get selectFamilyToViewMembers => '请选择一个家庭查看成员';

  @override
  String get createFamily => '创建家庭';

  @override
  String get familyName => '家庭名称';

  @override
  String get joinFamily => '加入家庭';

  @override
  String get inviteCode => '邀请码';

  @override
  String get displayName => '你的显示名称';

  @override
  String get create => '创建';

  @override
  String get join => '加入';

  @override
  String get settingsGeneral => '通用';

  @override
  String get language => '语言';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get english => 'English';

  @override
  String get currency => '货币';

  @override
  String get currencyCNY => 'CNY ¥';

  @override
  String get about => '关于';

  @override
  String get aboutDescription => '一款面向家庭的移动端记账应用。';

  @override
  String get logout => '退出登录';

  @override
  String get categoryManagement => '分类管理';

  @override
  String get addCategory => '添加分类';

  @override
  String get categoryName => '分类名称';

  @override
  String get parentCategory => '父分类';

  @override
  String get noParent => '无（顶级分类）';

  @override
  String get deleteCategoryConfirm => '确定删除该分类？';

  @override
  String get categoryDeleted => '分类已删除';

  @override
  String get categoryCreated => '分类已创建';

  @override
  String get manageCategories => '管理';

  @override
  String get singleFamilyHint => '每个账号只能加入一个家庭';

  @override
  String get noFamilyHint => '创建或加入一个家庭开始记账';
}
