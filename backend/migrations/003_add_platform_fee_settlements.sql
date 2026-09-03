-- Migration: 003_add_platform_fee_settlements.sql
-- Adds platform_fee_settlements ledger and settlement tracking to orders.

CREATE TABLE IF NOT EXISTS platform_fee_settlements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    merchant_id UUID NOT NULL REFERENCES merchants(id) ON DELETE CASCADE,
    amount_in_paise INT NOT NULL,
    orders_count INT NOT NULL DEFAULT 0,
    payment_gateway VARCHAR(50) NOT NULL DEFAULT 'phonepe',
    payment_transaction_id VARCHAR(255),
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    settled_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_platform_fee_settlements_merchant 
    ON platform_fee_settlements(merchant_id, created_at DESC);

CREATE INDEX IF NOT EXISTS idx_platform_fee_settlements_tx_id 
    ON platform_fee_settlements(payment_transaction_id);

ALTER TABLE orders ADD COLUMN IF NOT EXISTS platform_fee_settled BOOLEAN NOT NULL DEFAULT FALSE;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS platform_fee_settlement_id UUID REFERENCES platform_fee_settlements(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_orders_unsettled_fees 
    ON orders(store_id, platform_fee_settled) WHERE platform_fee_settled = FALSE;

