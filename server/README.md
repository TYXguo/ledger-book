# Ledger Book API

家庭记账应用的后端服务。

## 技术栈

- **Runtime**: Node.js + TypeScript
- **Framework**: Fastify
- **ORM**: Prisma
- **Database**: PostgreSQL 16
- **Cache**: Redis 7
- **Auth**: JWT + bcryptjs

## 环境要求

- Docker & Docker Compose
- Node.js 20+

## 快速启动

### 1. 启动基础设施

```bash
docker compose up -d
```

> 启动后，PostgreSQL 默认运行在 `localhost:5432`，Redis 默认运行在 `localhost:6379`。

### 2. 安装依赖

```bash
cd server
npm install
```

### 3. 运行数据库迁移

```bash
npx prisma generate
npx prisma migrate dev
```

### 4. 初始化系统分类

```bash
npm run db:seed
```

### 5. 启动开发服务器

```bash
npm run dev
```

> 启动成功后，服务默认运行在 http://localhost:3000

### 6. 验证服务

```bash
curl http://localhost:3000/health
```

返回 `"ok"` 表示服务正常运行。

## API 接口列表

| 方法 | 接口 | 鉴权 | 说明 |
|--------|----------|------|-------------|
| POST | /auth/register | 否 | 注册用户 |
| POST | /auth/login | 否 | 用户登录 |
| GET | /health | 否 | 健康检查 |
| POST | /families | 是 | 创建家庭 |
| POST | /families/join | 是 | 加入家庭 |
| GET | /families | 是 | 获取用户的家庭列表 |
| GET | /families/:id/members | 是 | 获取家庭成员列表 |
| GET/POST | /families/:id/categories | 是 | 获取/创建分类 |
| GET/POST | /families/:id/tags | 是 | 获取/创建标签 |
| GET/POST | /families/:id/transactions | 是 | 获取/创建交易记录 |
| POST | /families/:id/budgets | 是 | 更新预算 |
| GET | /families/:id/budgets/summary | 是 | 获取预算摘要 |
| GET | /families/:id/statistics/overview | 是 | 获取今日/本周/本月概览 |
| GET | /families/:id/statistics/category-breakdown | 是 | 获取分类统计饼图数据 |
| GET | /families/:id/statistics/monthly-trend | 是 | 获取月度趋势折线图数据 |
| POST/GET | /families/:id/transfers | 是 | 创建/获取转账记录 |
| GET | /families/:id/members/:mid/balance | 是 | 获取成员余额 |

## 查看数据库数据

### 1. Prisma Studio（推荐，可视化界面）

```bash
npx prisma studio
```

会在浏览器打开一个可视化界面，可以浏览所有表的数据。

### 2. 直接连 PostgreSQL

```bash
# 用 psql 命令行
psql -h localhost -U postgres -d ledger_book

# 或者用 Docker 内的 psql
docker compose exec postgres psql -U postgres -d ledger_book
```

连接后可以查看表和数据：

```sql
\dt                          -- 列出所有表
SELECT * FROM app_user;      -- 查看用户表
SELECT * FROM family;        -- 查看家庭表
SELECT * FROM transaction;   -- 查看交易记录
```

### 3. GUI 客户端工具

可以安装图形化工具来更方便地查看：
- **TablePlus**（macOS 推荐）
- **DBeaver**（免费跨平台）
- **Postico**（macOS）

连接信息参考 `.env` 或 `.env.example` 中的 `DATABASE_URL`。

## 环境变量

配置项详见 `.env.example`。
