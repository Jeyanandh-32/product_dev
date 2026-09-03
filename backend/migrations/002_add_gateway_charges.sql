-- Migration: 002_add_gateway_charges.sql
-- Add gateway_charges to orders, and gateway_charges + platform_fee to customer_wallet_transactions.

ALTER TABLE orders ADD COLUMN IF NOT EXISTS gateway_charges INT NOT NULL DEFAULT 0;
ALTER TABLE customer_wallet_transactions ADD COLUMN IF NOT EXISTS gateway_charges INT NOT NULL DEFAULT 0;
ALTER TABLE customer_wallet_transactions ADD COLUMN IF NOT EXISTS platform_fee INT NOT NULL DEFAULT 0;
