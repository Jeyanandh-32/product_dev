-- Active: 1780574462311@@127.0.0.1@5432@test_db

CREATE TABLE IF NOT EXISTS merchants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    name VARCHAR(255) NOT NULL,
    business_name VARCHAR(255) NOT NULL,
    whatsapp_number VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_merchants_email ON merchants (email);

CREATE TABLE IF NOT EXISTS subscription_plans (
    code VARCHAR(50) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price_in_paise INT NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'INR',
    max_terminals INT NOT NULL DEFAULT 5,
    max_inventory_items INT NOT NULL DEFAULT 50,
    features JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS stores (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    merchant_id UUID NOT NULL REFERENCES merchants (id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    store_type VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_merchant_store_name UNIQUE (merchant_id, name)
);

CREATE TABLE IF NOT EXISTS store_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
    plan_code VARCHAR(50) NOT NULL REFERENCES subscription_plans (code) ON DELETE CASCADE,
    status VARCHAR(50) NOT NULL DEFAULT 'ACTIVE',
    current_period_start TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    current_period_end TIMESTAMPTZ NOT NULL,
    trial_end TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_store_subscriptions_status ON store_subscriptions (status);

CREATE TABLE IF NOT EXISTS terminals (
    code VARCHAR(12) PRIMARY KEY,
    merchant_id UUID NOT NULL REFERENCES merchants (id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_store_terminal_name UNIQUE (store_id, name)
);

CREATE TABLE IF NOT EXISTS counters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    name VARCHAR(255) NOT NULL,
    merchant_id UUID NOT NULL REFERENCES merchants (id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    description VARCHAR(255),
    image_url VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_store_counter_name UNIQUE (store_id, name)
);

CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    name VARCHAR(255) NOT NULL,
    merchant_id UUID NOT NULL REFERENCES merchants (id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    description VARCHAR(255),
    image_url VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_store_category_name UNIQUE (store_id, name)
);
