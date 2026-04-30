# Ledger Book

家庭记账应用，支持多成员管理、预算控制和数据可视化。

## 项目结构

```
.
├── server/          # Node.js + Fastify 后端服务
├── mobile/          # Flutter 移动客户端（Android & iOS）
├── docker-compose.yml
└── README.md
```

## 环境要求

- Docker & Docker Compose
- Node.js 20+
- Flutter 3.x SDK
- Android Studio（Android）/ Xcode（iOS）

## 快速启动

### 1. 启动数据库

```bash
docker compose up -d
```

> 启动 PostgreSQL（localhost:5432）和 Redis（localhost:6379）。

### 2. 启动后端服务

```bash
cd server
npm install
npx prisma generate
npx prisma migrate dev
npm run db:seed
npm run dev
```

> 服务默认运行在 http://localhost:3000

### 3. 启动移动客户端

```bash
cd mobile
flutter pub get
flutter run
```

## 核心功能

- 快速记账（收入 / 支出）
- 自定义分类（父子分类）
- 标签和备注
- 首页今日 / 本周 / 本月概览
- 交易列表（搜索、筛选）
- 饼图（分类占比）和折线图（月度趋势）
- 月度预算与超支提醒
- 家庭成员管理
- 按成员 / 全家统计
- 成员间转账（借款、还款、存入、取出）
- 成员间余额计算

## 技术栈

| 层级 | 技术 |
|------|------|
| 移动端 | Flutter 3, Dart, Riverpod, go_router, fl_chart |
| API | Node.js, TypeScript, Fastify |
| ORM | Prisma |
| 数据库 | PostgreSQL 16 |
| 缓存 | Redis 7 |
| 鉴权 | JWT |
