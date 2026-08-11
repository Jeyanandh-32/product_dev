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
    slug VARCHAR(255) UNIQUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_merchant_store_name UNIQUE (merchant_id, name),
    CONSTRAINT check_online_slug CHECK (
        (is_online_enabled = FALSE) OR (is_online_enabled = TRUE AND slug IS NOT NULL AND slug != '')
    )
);

CREATE INDEX IF NOT EXISTS idx_stores_online_slug ON stores (is_online_enabled, slug);

CREATE TABLE IF NOT EXISTS store_subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    merchant_id UUID NOT NULL REFERENCES merchants (id) ON DELETE CASCADE,
    plan_code VARCHAR(50) NOT NULL REFERENCES subscription_plans (code),
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    starts_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ends_at TIMESTAMPTZ,
    auto_renew BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

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
    discount_total INT NOT NULL DEFAULT 0
);

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

CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_orders_order_reference ON orders(order_reference);
CREATE INDEX IF NOT EXISTS idx_orders_store_created_at ON orders(store_id, created_at);
CREATE INDEX IF NOT EXISTS idx_stock_transactions_store_id ON stock_transactions(store_id);

