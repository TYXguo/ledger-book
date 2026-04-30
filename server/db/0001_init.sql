CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE app_user (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(64) UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  nickname VARCHAR(64) NOT NULL,
  avatar_url TEXT,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE family (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(128) NOT NULL,
  invite_code VARCHAR(32) UNIQUE NOT NULL,
  owner_user_id UUID NOT NULL REFERENCES app_user(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE family_member (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id UUID NOT NULL REFERENCES family(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES app_user(id),
  display_name VARCHAR(64) NOT NULL,
  role VARCHAR(16) NOT NULL DEFAULT 'member',
  is_default BOOLEAN NOT NULL DEFAULT false,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (family_id, user_id)
);

CREATE TABLE category (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id UUID REFERENCES family(id) ON DELETE CASCADE,
  created_by_user_id UUID REFERENCES app_user(id),
  parent_id UUID REFERENCES category(id) ON DELETE CASCADE,
  name VARCHAR(64) NOT NULL,
  type VARCHAR(8) NOT NULL CHECK (type IN ('income', 'expense')),
  icon VARCHAR(64),
  color VARCHAR(32),
  sort_order INT NOT NULL DEFAULT 0,
  is_system BOOLEAN NOT NULL DEFAULT false,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE tag (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id UUID REFERENCES family(id) ON DELETE CASCADE,
  created_by_user_id UUID REFERENCES app_user(id),
  name VARCHAR(64) NOT NULL,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (family_id, name)
);

CREATE TABLE transaction (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id UUID NOT NULL REFERENCES family(id) ON DELETE CASCADE,
  created_by_user_id UUID NOT NULL REFERENCES app_user(id),
  owner_member_id UUID NOT NULL REFERENCES family_member(id),
  type VARCHAR(8) NOT NULL CHECK (type IN ('income', 'expense', 'transfer')),
  amount NUMERIC(14,2) NOT NULL CHECK (amount > 0),
  currency VARCHAR(8) NOT NULL DEFAULT 'CNY',
  category_id UUID NOT NULL REFERENCES category(id),
  sub_category_id UUID REFERENCES category(id),
  occurred_at TIMESTAMPTZ NOT NULL,
  note TEXT,
  is_excluded_from_statistics BOOLEAN NOT NULL DEFAULT false,
  status VARCHAR(16) NOT NULL DEFAULT 'active',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_transaction_family_occurred_at ON transaction(family_id, occurred_at DESC);
CREATE INDEX idx_transaction_family_member ON transaction(family_id, owner_member_id);
CREATE INDEX idx_transaction_family_category ON transaction(family_id, category_id);

CREATE TABLE transaction_tag (
  transaction_id UUID NOT NULL REFERENCES transaction(id) ON DELETE CASCADE,
  tag_id UUID NOT NULL REFERENCES tag(id) ON DELETE CASCADE,
  PRIMARY KEY (transaction_id, tag_id)
);

CREATE TABLE budget (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id UUID NOT NULL REFERENCES family(id) ON DELETE CASCADE,
  owner_member_id UUID REFERENCES family_member(id),
  category_id UUID REFERENCES category(id),
  budget_month DATE NOT NULL,
  amount NUMERIC(14,2) NOT NULL CHECK (amount >= 0),
  alert_threshold_percent SMALLINT NOT NULL DEFAULT 100,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (family_id, owner_member_id, category_id, budget_month)
);

CREATE TABLE transfer (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id UUID NOT NULL REFERENCES family(id) ON DELETE CASCADE,
  debtor_member_id UUID NOT NULL REFERENCES family_member(id),
  creditor_member_id UUID NOT NULL REFERENCES family_member(id),
  related_transfer_id UUID REFERENCES transfer(id),
  direction VARCHAR(16) NOT NULL CHECK (direction IN ('loan', 'repayment', 'deposit', 'withdrawal', 'adjustment')),
  reference_no VARCHAR(64) UNIQUE NOT NULL,
  amount NUMERIC(14,2) NOT NULL CHECK (amount > 0),
  currency VARCHAR(8) NOT NULL DEFAULT 'CNY',
  note TEXT,
  related_transaction_id UUID REFERENCES transaction(id),
  occurred_at TIMESTAMPTZ NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'completed' CHECK (status IN ('pending', 'completed', 'cancelled', 'reversed')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_transfer_family_from ON transfer(family_id, debtor_member_id);
CREATE INDEX idx_transfer_family_to ON transfer(family_id, creditor_member_id);
CREATE INDEX idx_transfer_family_occurred_at ON transfer(family_id, occurred_at DESC);

CREATE VIEW v_transfer_balance AS
SELECT
  t.family_id,
  t.debtor_member_id AS member_id,
  t.creditor_member_id AS peer_member_id,
  SUM(
    CASE
      WHEN t.direction IN ('loan', 'deposit') THEN t.amount
      WHEN t.direction IN ('repayment', 'withdrawal') THEN -t.amount
      ELSE 0
    END
  ) AS balance_to_peer
FROM transfer t
WHERE t.status = 'completed'
GROUP BY t.family_id, t.debtor_member_id, t.creditor_member_id;
