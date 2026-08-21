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
CREATE INDEX IF NOT EXISTS idx_merchants_whatsapp ON merchants (whatsapp_number);

CREATE TABLE IF NOT EXISTS merchant_settings (
    merchant_id UUID PRIMARY KEY REFERENCES merchants (id) ON DELETE CASCADE,
    wa_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    low_stock_alerts BOOLEAN NOT NULL DEFAULT TRUE,
    daily_reports BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    name VARCHAR(255) NOT NULL,
    mobile_number VARCHAR(15) UNIQUE NOT NULL,
    pin_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_customers_mobile ON customers (mobile_number);

CREATE TABLE IF NOT EXISTS customer_store_wallets (
    customer_id UUID NOT NULL REFERENCES customers (id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
    wallet_balance INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (customer_id, store_id)
);

CREATE INDEX IF NOT EXISTS idx_customer_store_wallets_store ON customer_store_wallets (store_id);

CREATE TABLE IF NOT EXISTS customer_wallet_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    customer_id UUID NOT NULL REFERENCES customers (id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
    amount INT NOT NULL,
    type VARCHAR(50) NOT NULL,
    reference VARCHAR(255),
    status VARCHAR(50) NOT NULL DEFAULT 'completed',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_customer_wallet_tx_customer_store ON customer_wallet_transactions (customer_id, store_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_customer_wallet_tx_store ON customer_wallet_transactions (store_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_customer_wallet_tx_reference ON customer_wallet_transactions (reference);

CREATE TABLE IF NOT EXISTS customer_recent_stores (
    customer_id UUID NOT NULL REFERENCES customers (id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
    last_visited_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (customer_id, store_id)
);

CREATE INDEX IF NOT EXISTS idx_customer_recent_stores ON customer_recent_stores (customer_id, last_visited_at DESC);

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
    is_online_enabled BOOLEAN NOT NULL DEFAULT FALSE,
    active_payment_provider VARCHAR(50) DEFAULT 'phonepe',
    slug VARCHAR(255) UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_merchant_store_name UNIQUE (merchant_id, name),
    CONSTRAINT check_online_slug CHECK (
        (is_online_enabled = FALSE) OR (is_online_enabled = TRUE AND slug IS NOT NULL AND slug != '')
    )
);

CREATE INDEX IF NOT EXISTS idx_stores_merchant_active ON stores (merchant_id, is_active);
CREATE INDEX IF NOT EXISTS idx_stores_online_slug ON stores (is_online_enabled, slug);

CREATE TABLE IF NOT EXISTS store_phonepe_configs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    store_id UUID NOT NULL UNIQUE REFERENCES stores (id) ON DELETE CASCADE,
    is_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    env VARCHAR(20) NOT NULL DEFAULT 'UAT',
    client_id VARCHAR(100),
    client_version VARCHAR(50),
    client_secret TEXT,
    salt_key TEXT,
    salt_index INT NOT NULL DEFAULT 1,
    enable_upi BOOLEAN NOT NULL DEFAULT TRUE,
    enable_cards BOOLEAN NOT NULL DEFAULT FALSE,
    enable_net_banking BOOLEAN NOT NULL DEFAULT FALSE,
    enable_emi BOOLEAN NOT NULL DEFAULT FALSE,
    enable_wallets BOOLEAN NOT NULL DEFAULT FALSE,
    allowed_upi_apps TEXT,
    webhook_auth_type VARCHAR(20) NOT NULL DEFAULT 'HMAC',
    webhook_secret_key TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS store_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
    plan_code VARCHAR(50) NOT NULL REFERENCES subscription_plans (code),
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    starts_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ends_at TIMESTAMPTZ,
    auto_renew BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_store_subscriptions_store ON store_subscriptions (store_id, status);

CREATE TABLE IF NOT EXISTS terminals (
    code VARCHAR(12) PRIMARY KEY,
    store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_store_terminal_name UNIQUE (store_id, name)
);

CREATE INDEX IF NOT EXISTS idx_terminals_store_active ON terminals (store_id, is_active);

CREATE TABLE IF NOT EXISTS counters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_store_counter_name UNIQUE (store_id, name)
);

CREATE INDEX IF NOT EXISTS idx_counters_store_active ON counters (store_id, is_active);

CREATE TABLE IF NOT EXISTS categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_store_category_name UNIQUE (store_id, name)
);

CREATE INDEX IF NOT EXISTS idx_categories_store_active ON categories (store_id, is_active);

CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
    category_id UUID NOT NULL REFERENCES categories (id) ON DELETE RESTRICT,
    counter_id UUID REFERENCES counters (id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    base_price INT NOT NULL,
    tax_rate NUMERIC(5, 2) NOT NULL DEFAULT 0.00,
    selling_price INT NOT NULL,
    sku VARCHAR(100),
    barcode VARCHAR(100),
    description TEXT,
    image_url TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_store_product_name UNIQUE (store_id, name)
);

CREATE INDEX IF NOT EXISTS idx_products_store_active ON products (store_id, is_active);
CREATE INDEX IF NOT EXISTS idx_products_store_category ON products (store_id, category_id, is_active);
CREATE INDEX IF NOT EXISTS idx_products_store_counter ON products (store_id, counter_id, is_active);
CREATE INDEX IF NOT EXISTS idx_products_sku ON products (sku);
CREATE INDEX IF NOT EXISTS idx_products_barcode ON products (barcode);

CREATE TABLE IF NOT EXISTS stocks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    store_id UUID NOT NULL REFERENCES stores (id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products (id) ON DELETE CASCADE,
    quantity INT NOT NULL DEFAULT 0,
    low_stock_threshold INT NOT NULL DEFAULT 10,
    stock_monitor BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_store_product_stock UNIQUE (store_id, product_id)
);

CREATE INDEX IF NOT EXISTS idx_stocks_product ON stocks (product_id);
CREATE INDEX IF NOT EXISTS idx_stocks_store_monitor ON stocks (store_id, stock_monitor, quantity, low_stock_threshold);

CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    order_reference VARCHAR(50) NOT NULL UNIQUE,
    bill_no INT NOT NULL,
    source VARCHAR(20) NOT NULL,
    type VARCHAR(20) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    payment_status VARCHAR(20) NOT NULL DEFAULT 'unpaid' CHECK (payment_status IN ('unpaid', 'paid', 'refunded', 'cancelled')),
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('cash', 'upi', 'complimentary')),
    subtotal INT NOT NULL,
    tax_total INT NOT NULL,
    grand_total INT NOT NULL,
    terminal_code VARCHAR(12) REFERENCES terminals(code) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    discount_total INT NOT NULL DEFAULT 0,
    wallet_deduction INT NOT NULL DEFAULT 0,
    customer_id UUID REFERENCES customers(id) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_orders_order_reference ON orders(order_reference);
CREATE INDEX IF NOT EXISTS idx_orders_store_created_at ON orders(store_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_store_terminal ON orders(store_id, terminal_code, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_store_source_created ON orders(store_id, source, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_store_status ON orders(store_id, status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_store_pay_status ON orders(store_id, payment_status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_customer_created ON orders(customer_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_merchant_created ON orders(merchant_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_bill_no ON orders(store_id, bill_no);

CREATE TABLE IF NOT EXISTS order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price INT NOT NULL,
    tax_rate NUMERIC(5, 2) NOT NULL,
    discount INT NOT NULL DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_order_items_store_id ON order_items(store_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_store ON order_items(order_id, store_id);

CREATE TABLE IF NOT EXISTS stock_transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    store_id UUID NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
    adjustment_type VARCHAR(20) NOT NULL,
    quantity INT NOT NULL,
    reason VARCHAR(50) NOT NULL,
    custom_reason TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_stock_transactions_store_id ON stock_transactions(store_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_stock_transactions_product_store ON stock_transactions(store_id, product_id, created_at DESC);
