#!/usr/bin/env bash
# ==============================================================================
# Database Reset & Cleanup Script (Local & Staging)
# ==============================================================================
# Clears:
#   - All orders, order items, and bottle QR tokens
#   - Bottle return transactions, physical coupons, and resets bottle credits to 0
#   - Customer wallet transactions
#   - Stock audit logs (stock_transactions)
#   - Resets all product stocks to 100 (or custom quantity)
#
# Usage:
#   ./reset_db.sh                     # Resets Local DB (backend-database-1)
#   ./reset_db.sh --stage             # Resets Staging DB on EC2 (pos_stage_db)
#   ./reset_db.sh --stage --stocks=50 # Resets Staging DB with stocks=50
#   ./reset_db.sh --help              # View all options
# ==============================================================================

set -eo pipefail

ENV_FILE="backend/.env"
[ ! -f "$ENV_FILE" ] && [ -f ".env" ] && ENV_FILE=".env"

TARGET="local"
STOCK_QTY=100
CUSTOM_HOST=""
CUSTOM_PORT=""
CUSTOM_DB=""
CUSTOM_USER=""
CUSTOM_PASS=""
CONTAINER_NAME=""

# Staging EC2 defaults
STAGE_SSH_KEY="$HOME/.ssh/saas-key.pem"
STAGE_SSH_USER="ubuntu"
STAGE_SSH_HOST="13.232.157.37"
STAGE_CONTAINER="pos_stage_db"
STAGE_DB="test_db"
STAGE_USER="postgres"

for arg in "$@"; do
  case "$arg" in
    --stage|-s)
      TARGET="stage"
      ;;
    --local|-l)
      TARGET="local"
      ;;
    --stocks=*)
      STOCK_QTY="${arg#*=}"
      ;;
    --env=*)
      ENV_FILE="${arg#*=}"
      ;;
    --host=*)
      CUSTOM_HOST="${arg#*=}"
      ;;
    --port=*)
      CUSTOM_PORT="${arg#*=}"
      ;;
    --db=*)
      CUSTOM_DB="${arg#*=}"
      ;;
    --user=*)
      CUSTOM_USER="${arg#*=}"
      ;;
    --pass=*)
      CUSTOM_PASS="${arg#*=}"
      ;;
    --container=*)
      CONTAINER_NAME="${arg#*=}"
      ;;
    -h|--help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Targets:"
      echo "  --stage, -s          Reset Staging DB on EC2 ($STAGE_SSH_HOST -> $STAGE_CONTAINER)"
      echo "  --local, -l          Reset Local DB (default)"
      echo ""
      echo "Options:"
      echo "  --stocks=<qty>       Stock quantity to reset to (default: 100)"
      echo "  --env=<path>         Path to .env file (default: backend/.env)"
      echo "  --host=<host>        PostgreSQL host"
      echo "  --port=<port>        PostgreSQL port"
      echo "  --db=<name>          Database name"
      echo "  --user=<username>    Database user"
      echo "  --pass=<password>    Database password"
      echo "  --container=<name>   Docker container name"
      echo "  -h, --help           Show this help message"
      exit 0
      ;;
  esac
done

SQL_CMDS=$(cat <<EOF
BEGIN;

-- 1. Orders and dependent items
TRUNCATE TABLE bottle_qr_tokens CASCADE;
TRUNCATE TABLE order_items CASCADE;
TRUNCATE TABLE orders CASCADE;

-- 2. Bottle return transactions & coupons
TRUNCATE TABLE bottle_credit_transactions CASCADE;
TRUNCATE TABLE bottle_physical_coupons CASCADE;
UPDATE bottle_credits SET balance = 0;

-- 3. Customer wallet transactions
TRUNCATE TABLE customer_wallet_transactions CASCADE;

-- 4. Platform fee settlements
TRUNCATE TABLE platform_fee_settlements CASCADE;

-- 5. Stock audit and stock reset
TRUNCATE TABLE stock_transactions CASCADE;
UPDATE stocks SET quantity = $STOCK_QTY;

COMMIT;
EOF
)

if [ "$TARGET" = "stage" ]; then
  echo "========================================"
  echo "  STAGING DATABASE RESET & CLEANUP"
  echo "========================================"
  echo "Target:      STAGING (EC2 $STAGE_SSH_HOST)"
  echo "Container:   $STAGE_CONTAINER"
  echo "Database:    $STAGE_DB"
  echo "Stock Reset: $STOCK_QTY units"
  echo "----------------------------------------"

  if [ ! -f "$STAGE_SSH_KEY" ]; then
    echo "ERROR: SSH key not found at $STAGE_SSH_KEY"
    exit 1
  fi

  echo "Connecting to staging EC2 via SSH..."
  echo "$SQL_CMDS" | ssh -i "$STAGE_SSH_KEY" -o StrictHostKeyChecking=no "$STAGE_SSH_USER@$STAGE_SSH_HOST" \
    "docker exec -i $STAGE_CONTAINER psql -U $STAGE_USER -d $STAGE_DB"

  echo "----------------------------------------"
  echo " SUCCESS: Staging DB cleared & stocks reset to $STOCK_QTY!"
  echo "========================================"
  exit 0
fi

# Local execution
if [ -f "$ENV_FILE" ]; then
  while IFS='=' read -r key val || [ -n "$key" ]; do
    [[ "$key" =~ ^#.*$ ]] && continue
    [ -z "$key" ] && continue
    key=$(echo "$key" | xargs)
    val=$(echo "$val" | xargs)
    case "$key" in
      DB_HOST) [ -z "$CUSTOM_HOST" ] && CUSTOM_HOST="$val" ;;
      DB_PORT) [ -z "$CUSTOM_PORT" ] && CUSTOM_PORT="$val" ;;
      DB_NAME) [ -z "$CUSTOM_DB" ] && CUSTOM_DB="$val" ;;
      DB_USERNAME) [ -z "$CUSTOM_USER" ] && CUSTOM_USER="$val" ;;
      DB_PASSWORD) [ -z "$CUSTOM_PASS" ] && CUSTOM_PASS="$val" ;;
    esac
  done < "$ENV_FILE"
fi

DB_HOST="${CUSTOM_HOST:-127.0.0.1}"
DB_PORT="${CUSTOM_PORT:-5432}"
DB_NAME="${CUSTOM_DB:-test_db}"
DB_USER="${CUSTOM_USER:-postgres}"
DB_PASS="${CUSTOM_PASS:-postgres}"

echo "========================================"
echo "  LOCAL DATABASE RESET & CLEANUP"
echo "========================================"
echo "Host:        $DB_HOST:$DB_PORT"
echo "Database:    $DB_NAME"
echo "User:        $DB_USER"
echo "Env File:    $ENV_FILE"
echo "Stock Reset: $STOCK_QTY units"
echo "----------------------------------------"

USE_DOCKER=false
if [ -n "$CONTAINER_NAME" ]; then
  USE_DOCKER=true
elif command -v psql >/dev/null 2>&1 && psql -V >/dev/null 2>&1; then
  USE_DOCKER=false
elif command -v docker >/dev/null 2>&1 && docker ps --format '{{.Names}}' | grep -q "backend-database-1"; then
  USE_DOCKER=true
  CONTAINER_NAME="backend-database-1"
fi

if [ "$USE_DOCKER" = true ]; then
  CONTAINER="${CONTAINER_NAME:-backend-database-1}"
  echo "Using Docker container: $CONTAINER"
  echo "$SQL_CMDS" | docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME"
else
  export PGPASSWORD="$DB_PASS"
  echo "$SQL_CMDS" | psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME"
fi

echo "----------------------------------------"
echo " SUCCESS: Local DB cleared & stocks reset to $STOCK_QTY!"
echo "========================================"
