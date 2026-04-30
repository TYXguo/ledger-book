-- CreateTable
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE "app_user" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "email" VARCHAR(255),
    "phone" VARCHAR(64),
    "password_hash" VARCHAR(255) NOT NULL,
    "nickname" VARCHAR(64) NOT NULL,
    "avatar_url" TEXT,
    "status" VARCHAR(16) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT "app_user_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "app_user_email_key" ON "app_user"("email");
CREATE UNIQUE INDEX "app_user_phone_key" ON "app_user"("phone");

CREATE TABLE "family" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" VARCHAR(128) NOT NULL,
    "invite_code" VARCHAR(32) NOT NULL,
    "owner_user_id" UUID NOT NULL,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT "family_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "family_invite_code_key" ON "family"("invite_code");

CREATE TABLE "family_member" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "family_id" UUID NOT NULL,
    "user_id" UUID NOT NULL,
    "display_name" VARCHAR(64) NOT NULL,
    "role" VARCHAR(16) NOT NULL DEFAULT 'member',
    "is_default" BOOLEAN NOT NULL DEFAULT false,
    "status" VARCHAR(16) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT "family_member_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "family_member_family_id_user_id_key" ON "family_member"("family_id", "user_id");

CREATE TABLE "category" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "family_id" UUID,
    "created_by_user_id" UUID,
    "parent_id" UUID,
    "name" VARCHAR(64) NOT NULL,
    "type" VARCHAR(8) NOT NULL,
    "icon" VARCHAR(64),
    "color" VARCHAR(32),
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "is_system" BOOLEAN NOT NULL DEFAULT false,
    "status" VARCHAR(16) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT "category_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "category_type_check" CHECK ("type" IN ('income', 'expense'))
);

CREATE TABLE "tag" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "family_id" UUID,
    "created_by_user_id" UUID,
    "name" VARCHAR(64) NOT NULL,
    "status" VARCHAR(16) NOT NULL DEFAULT 'active',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT "tag_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "tag_family_id_name_key" ON "tag"("family_id", "name");

CREATE TABLE "transaction" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "family_id" UUID NOT NULL,
    "created_by_user_id" UUID NOT NULL,
    "owner_member_id" UUID NOT NULL,
    "type" VARCHAR(8) NOT NULL,
    "amount" DECIMAL(14,2) NOT NULL,
    "currency" VARCHAR(8) NOT NULL DEFAULT 'CNY',
    "category_id" UUID NOT NULL,
    "sub_category_id" UUID,
    "occurred_at" TIMESTAMPTZ NOT NULL,
    "note" TEXT,
    "is_excluded_from_statistics" BOOLEAN NOT NULL DEFAULT false,
    "status" VARCHAR(16) NOT NULL DEFAULT 'active',
    "deleted_at" TIMESTAMPTZ,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT "transaction_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "transaction_type_check" CHECK ("type" IN ('income', 'expense', 'transfer'))
);

CREATE INDEX "idx_transaction_family_occurred_at" ON "transaction"("family_id", "occurred_at" DESC);
CREATE INDEX "idx_transaction_family_member" ON "transaction"("family_id", "owner_member_id");
CREATE INDEX "idx_transaction_family_category" ON "transaction"("family_id", "category_id");

CREATE TABLE "transaction_tag" (
    "transaction_id" UUID NOT NULL,
    "tag_id" UUID NOT NULL,

    CONSTRAINT "transaction_tag_pkey" PRIMARY KEY ("transaction_id", "tag_id")
);

CREATE TABLE "budget" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "family_id" UUID NOT NULL,
    "owner_member_id" UUID,
    "category_id" UUID,
    "budget_month" DATE NOT NULL,
    "amount" DECIMAL(14,2) NOT NULL,
    "alert_threshold_percent" SMALLINT NOT NULL DEFAULT 100,
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT "budget_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "budget_family_id_owner_member_id_category_id_budget_month" ON "budget"("family_id", "owner_member_id", "category_id", "budget_month");

CREATE TABLE "transfer" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "family_id" UUID NOT NULL,
    "debtor_member_id" UUID NOT NULL,
    "creditor_member_id" UUID NOT NULL,
    "related_transfer_id" UUID,
    "direction" VARCHAR(16) NOT NULL,
    "reference_no" VARCHAR(64) NOT NULL,
    "amount" DECIMAL(14,2) NOT NULL,
    "currency" VARCHAR(8) NOT NULL DEFAULT 'CNY',
    "note" TEXT,
    "related_transaction_id" UUID,
    "occurred_at" TIMESTAMPTZ NOT NULL,
    "status" VARCHAR(20) NOT NULL DEFAULT 'completed',
    "created_at" TIMESTAMPTZ NOT NULL DEFAULT now(),
    "updated_at" TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT "transfer_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "transfer_direction_check" CHECK ("direction" IN ('loan', 'repayment', 'deposit', 'withdrawal', 'adjustment')),
    CONSTRAINT "transfer_status_check" CHECK ("status" IN ('pending', 'completed', 'cancelled', 'reversed'))
);

CREATE UNIQUE INDEX "transfer_reference_no_key" ON "transfer"("reference_no");
CREATE INDEX "idx_transfer_family_from" ON "transfer"("family_id", "debtor_member_id");
CREATE INDEX "idx_transfer_family_to" ON "transfer"("family_id", "creditor_member_id");
CREATE INDEX "idx_transfer_family_occurred_at" ON "transfer"("family_id", "occurred_at" DESC);

-- AddForeignKey
ALTER TABLE "family" ADD CONSTRAINT "family_owner_user_id_fkey" FOREIGN KEY ("owner_user_id") REFERENCES "app_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "family_member" ADD CONSTRAINT "family_member_family_id_fkey" FOREIGN KEY ("family_id") REFERENCES "family"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "family_member" ADD CONSTRAINT "family_member_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "app_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "category" ADD CONSTRAINT "category_family_id_fkey" FOREIGN KEY ("family_id") REFERENCES "family"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "category" ADD CONSTRAINT "category_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "app_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "category" ADD CONSTRAINT "category_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "category"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "tag" ADD CONSTRAINT "tag_family_id_fkey" FOREIGN KEY ("family_id") REFERENCES "family"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "tag" ADD CONSTRAINT "tag_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "app_user"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "transaction" ADD CONSTRAINT "transaction_family_id_fkey" FOREIGN KEY ("family_id") REFERENCES "family"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "transaction" ADD CONSTRAINT "transaction_created_by_user_id_fkey" FOREIGN KEY ("created_by_user_id") REFERENCES "app_user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "transaction" ADD CONSTRAINT "transaction_owner_member_id_fkey" FOREIGN KEY ("owner_member_id") REFERENCES "family_member"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "transaction" ADD CONSTRAINT "transaction_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "transaction" ADD CONSTRAINT "transaction_sub_category_id_fkey" FOREIGN KEY ("sub_category_id") REFERENCES "category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "transaction_tag" ADD CONSTRAINT "transaction_tag_transaction_id_fkey" FOREIGN KEY ("transaction_id") REFERENCES "transaction"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "transaction_tag" ADD CONSTRAINT "transaction_tag_tag_id_fkey" FOREIGN KEY ("tag_id") REFERENCES "tag"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "budget" ADD CONSTRAINT "budget_family_id_fkey" FOREIGN KEY ("family_id") REFERENCES "family"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "budget" ADD CONSTRAINT "budget_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "category"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "transfer" ADD CONSTRAINT "transfer_family_id_fkey" FOREIGN KEY ("family_id") REFERENCES "family"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "transfer" ADD CONSTRAINT "transfer_debtor_member_id_fkey" FOREIGN KEY ("debtor_member_id") REFERENCES "family_member"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "transfer" ADD CONSTRAINT "transfer_creditor_member_id_fkey" FOREIGN KEY ("creditor_member_id") REFERENCES "family_member"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "transfer" ADD CONSTRAINT "transfer_related_transfer_id_fkey" FOREIGN KEY ("related_transfer_id") REFERENCES "transfer"("id") ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE "transfer" ADD CONSTRAINT "transfer_related_transaction_id_fkey" FOREIGN KEY ("related_transaction_id") REFERENCES "transaction"("id") ON DELETE SET NULL ON UPDATE CASCADE;
