import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// 应用标题
  ///
  /// In zh, this message translates to:
  /// **'家庭账本'**
  String get appTitle;

  /// 登录页面欢迎语
  ///
  /// In zh, this message translates to:
  /// **'欢迎回来！'**
  String get loginWelcome;

  /// 注册页面欢迎语
  ///
  /// In zh, this message translates to:
  /// **'创建你的账号'**
  String get loginCreateAccount;

  /// 昵称输入框标签
  ///
  /// In zh, this message translates to:
  /// **'昵称'**
  String get loginNickname;

  /// 邮箱/手机号输入框标签
  ///
  /// In zh, this message translates to:
  /// **'邮箱或手机号'**
  String get loginEmailOrPhone;

  /// 密码输入框标签
  ///
  /// In zh, this message translates to:
  /// **'密码'**
  String get loginPassword;

  /// 登录按钮
  ///
  /// In zh, this message translates to:
  /// **'登录'**
  String get login;

  /// 注册按钮
  ///
  /// In zh, this message translates to:
  /// **'注册'**
  String get register;

  /// 跳转注册的链接文字
  ///
  /// In zh, this message translates to:
  /// **'没有账号？注册'**
  String get loginNoAccount;

  /// 跳转登录的链接文字
  ///
  /// In zh, this message translates to:
  /// **'已有账号？登录'**
  String get loginHasAccount;

  /// 未填写完整时的提示
  ///
  /// In zh, this message translates to:
  /// **'请填写所有字段'**
  String get loginFillAll;

  /// 昵称为空时的提示
  ///
  /// In zh, this message translates to:
  /// **'请输入昵称'**
  String get loginEnterNickname;

  /// 首页最近交易标题
  ///
  /// In zh, this message translates to:
  /// **'最近交易'**
  String get homeRecentTransactions;

  /// 查看全部交易的按钮
  ///
  /// In zh, this message translates to:
  /// **'查看全部'**
  String get homeViewAll;

  /// 无交易记录时的空状态提示
  ///
  /// In zh, this message translates to:
  /// **'暂无交易记录，点击 + 添加一笔！'**
  String get homeNoTransactions;

  /// 底部导航-首页
  ///
  /// In zh, this message translates to:
  /// **'首页'**
  String get navHome;

  /// 底部导航-账单
  ///
  /// In zh, this message translates to:
  /// **'账单'**
  String get navBills;

  /// 底部导航-统计
  ///
  /// In zh, this message translates to:
  /// **'统计'**
  String get navStatistics;

  /// 底部导航-设置
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get navSettings;

  /// 总览卡片标题
  ///
  /// In zh, this message translates to:
  /// **'总览'**
  String get overview;

  /// 查看详情按钮
  ///
  /// In zh, this message translates to:
  /// **'详情'**
  String get details;

  /// 今日统计标签
  ///
  /// In zh, this message translates to:
  /// **'今日'**
  String get today;

  /// 本周统计标签
  ///
  /// In zh, this message translates to:
  /// **'本周'**
  String get thisWeek;

  /// 本月统计标签
  ///
  /// In zh, this message translates to:
  /// **'本月'**
  String get thisMonth;

  /// 快捷操作-预算
  ///
  /// In zh, this message translates to:
  /// **'预算'**
  String get quickBudget;

  /// 快捷操作-转账
  ///
  /// In zh, this message translates to:
  /// **'转账'**
  String get quickTransfer;

  /// 快捷操作-家庭
  ///
  /// In zh, this message translates to:
  /// **'家庭'**
  String get quickFamily;

  /// 快捷操作-账单
  ///
  /// In zh, this message translates to:
  /// **'账单'**
  String get quickBills;

  /// 添加交易页面标题
  ///
  /// In zh, this message translates to:
  /// **'添加交易'**
  String get addTransaction;

  /// 支出类型标签
  ///
  /// In zh, this message translates to:
  /// **'支出'**
  String get expense;

  /// 收入类型标签
  ///
  /// In zh, this message translates to:
  /// **'收入'**
  String get income;

  /// 分类标题
  ///
  /// In zh, this message translates to:
  /// **'分类'**
  String get category;

  /// 备注输入框标签
  ///
  /// In zh, this message translates to:
  /// **'备注'**
  String get note;

  /// 备注输入框占位文字
  ///
  /// In zh, this message translates to:
  /// **'添加备注...'**
  String get noteHint;

  /// 保存交易按钮
  ///
  /// In zh, this message translates to:
  /// **'保存交易'**
  String get saveTransaction;

  /// 金额无效时的提示
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的金额'**
  String get invalidAmount;

  /// 未选择分类时的提示
  ///
  /// In zh, this message translates to:
  /// **'请选择一个分类'**
  String get selectCategory;

  /// 交易保存成功的提示
  ///
  /// In zh, this message translates to:
  /// **'交易已保存！'**
  String get transactionSaved;

  /// 交易记录页面标题
  ///
  /// In zh, this message translates to:
  /// **'交易记录'**
  String get transactionRecords;

  /// 搜索框占位文字
  ///
  /// In zh, this message translates to:
  /// **'按备注搜索...'**
  String get searchByNote;

  /// 筛选-全部
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get all;

  /// 无搜索结果时的提示
  ///
  /// In zh, this message translates to:
  /// **'未找到交易记录'**
  String get noTransactionsFound;

  /// 分页-上一页
  ///
  /// In zh, this message translates to:
  /// **'上一页'**
  String get previousPage;

  /// 分页-下一页
  ///
  /// In zh, this message translates to:
  /// **'下一页'**
  String get nextPage;

  /// 统计页面标题
  ///
  /// In zh, this message translates to:
  /// **'统计'**
  String get statistics;

  /// 支出分类图表标题
  ///
  /// In zh, this message translates to:
  /// **'支出分类'**
  String get expenseCategories;

  /// 无支出数据时的提示
  ///
  /// In zh, this message translates to:
  /// **'暂无支出数据'**
  String get noExpenseData;

  /// 月度趋势图表标题
  ///
  /// In zh, this message translates to:
  /// **'月度趋势'**
  String get monthlyTrend;

  /// 无趋势数据时的提示
  ///
  /// In zh, this message translates to:
  /// **'暂无趋势数据'**
  String get noTrendData;

  /// 月份后缀，如 1月、2月
  ///
  /// In zh, this message translates to:
  /// **'{month}月'**
  String monthSuffix(int month);

  /// 预算页面标题
  ///
  /// In zh, this message translates to:
  /// **'预算'**
  String get budgetTitle;

  /// 未设置预算时的提示
  ///
  /// In zh, this message translates to:
  /// **'本月暂未设置预算'**
  String get noBudgetThisMonth;

  /// 引导设置预算的提示
  ///
  /// In zh, this message translates to:
  /// **'点击 + 设置预算'**
  String get clickToSetBudget;

  /// 月度预算卡片标题
  ///
  /// In zh, this message translates to:
  /// **'月度预算'**
  String get monthlyBudget;

  /// 超出预算的标签
  ///
  /// In zh, this message translates to:
  /// **'超出预算'**
  String get overBudget;

  /// 已支出金额
  ///
  /// In zh, this message translates to:
  /// **'已支出：{amount}'**
  String budgetSpent(String amount);

  /// 预算总金额
  ///
  /// In zh, this message translates to:
  /// **'预算：{amount}'**
  String budgetAmount(String amount);

  /// 剩余预算
  ///
  /// In zh, this message translates to:
  /// **'剩余：{amount}'**
  String budgetRemaining(String amount);

  /// 预算使用百分比
  ///
  /// In zh, this message translates to:
  /// **'已使用 {percent}%'**
  String budgetUsedPercent(String percent);

  /// 设置预算对话框标题
  ///
  /// In zh, this message translates to:
  /// **'设置预算'**
  String get setBudget;

  /// 预算金额输入框标签
  ///
  /// In zh, this message translates to:
  /// **'预算金额'**
  String get budgetAmountLabel;

  /// 取消按钮
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// 保存按钮
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// 转账页面标题
  ///
  /// In zh, this message translates to:
  /// **'转账'**
  String get transferTitle;

  /// 无转账记录时的提示
  ///
  /// In zh, this message translates to:
  /// **'暂无转账记录'**
  String get noTransfers;

  /// 引导添加转账的提示
  ///
  /// In zh, this message translates to:
  /// **'点击 + 记录一笔转账'**
  String get clickToAddTransfer;

  /// 转账类型-存入
  ///
  /// In zh, this message translates to:
  /// **'存入'**
  String get transferDeposit;

  /// 转账类型-取出
  ///
  /// In zh, this message translates to:
  /// **'取出'**
  String get transferWithdrawal;

  /// 转账类型-借出
  ///
  /// In zh, this message translates to:
  /// **'借出'**
  String get transferLoan;

  /// 转账类型-还款
  ///
  /// In zh, this message translates to:
  /// **'还款'**
  String get transferRepayment;

  /// 记录转账对话框标题
  ///
  /// In zh, this message translates to:
  /// **'记录转账'**
  String get recordTransfer;

  /// 金额输入框标签
  ///
  /// In zh, this message translates to:
  /// **'金额'**
  String get amount;

  /// 成员不足时的提示
  ///
  /// In zh, this message translates to:
  /// **'至少需要2名成员'**
  String get needTwoMembers;

  /// 家庭页面标题
  ///
  /// In zh, this message translates to:
  /// **'家庭'**
  String get familyTitle;

  /// 我的家庭标题
  ///
  /// In zh, this message translates to:
  /// **'我的家庭'**
  String get myFamily;

  /// 无家庭时的提示
  ///
  /// In zh, this message translates to:
  /// **'暂无家庭，创建或加入一个吧！'**
  String get noFamily;

  /// 角色标签
  ///
  /// In zh, this message translates to:
  /// **'角色：{role}'**
  String roleLabel(String role);

  /// 成员列表标题
  ///
  /// In zh, this message translates to:
  /// **'成员'**
  String get members;

  /// 未选择家庭时的提示
  ///
  /// In zh, this message translates to:
  /// **'请选择一个家庭查看成员'**
  String get selectFamilyToViewMembers;

  /// 创建家庭按钮/标题
  ///
  /// In zh, this message translates to:
  /// **'创建家庭'**
  String get createFamily;

  /// 家庭名称输入框标签
  ///
  /// In zh, this message translates to:
  /// **'家庭名称'**
  String get familyName;

  /// 加入家庭按钮/标题
  ///
  /// In zh, this message translates to:
  /// **'加入家庭'**
  String get joinFamily;

  /// 邀请码输入框标签
  ///
  /// In zh, this message translates to:
  /// **'邀请码'**
  String get inviteCode;

  /// 显示名称输入框标签
  ///
  /// In zh, this message translates to:
  /// **'你的显示名称'**
  String get displayName;

  /// 创建按钮
  ///
  /// In zh, this message translates to:
  /// **'创建'**
  String get create;

  /// 加入按钮
  ///
  /// In zh, this message translates to:
  /// **'加入'**
  String get join;

  /// 设置-通用分组标题
  ///
  /// In zh, this message translates to:
  /// **'通用'**
  String get settingsGeneral;

  /// 语言设置标签
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// 简体中文语言名称
  ///
  /// In zh, this message translates to:
  /// **'简体中文'**
  String get simplifiedChinese;

  /// English language name
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get english;

  /// 货币设置标签
  ///
  /// In zh, this message translates to:
  /// **'货币'**
  String get currency;

  /// 人民币货币格式
  ///
  /// In zh, this message translates to:
  /// **'CNY ¥'**
  String get currencyCNY;

  /// 关于页面标签
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get about;

  /// 应用简介
  ///
  /// In zh, this message translates to:
  /// **'一款面向家庭的移动端记账应用。'**
  String get aboutDescription;

  /// 退出登录按钮
  ///
  /// In zh, this message translates to:
  /// **'退出登录'**
  String get logout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
