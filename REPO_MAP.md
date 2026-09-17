# Finch POS — Repo Map

Melos monorepo. All-Dart stack: Dart Frog backend + PostgreSQL, Jaspr SSR
for merchant/customer web, Flutter for the terminal POS app.

## backend/ — Dart Frog API server
```
lib/
  database/
    schema/          # Postgres table schemas (order, product_stock, merchant,
                      # store, terminal, subscription, bottle_return_*, etc.)
    enums/            # user_role.dart
    exceptions/        # subscription_exceptions.dart
    extensions/        # row -> model extensions per table
    middlewares/        # auth_middleware.dart, cors_middleware.dart
    models/token_payload/
    repositories/       # one repo per domain: order, product, stock, store,
                        # subscription, customer, merchant, bottle_return,
                        # dashboard_analytics, profit_loss, platform_fee, etc.
    services/           # auth, order_service, order_calculator,
                        # phonepe_* (payment gateway), bottle_reward_wallet,
                        # customer_wallet_handler, cache/in_memory_cache
    utils/
  main.dart
  migrations/            # 001_initial.sql, 002_add_gateway_charges.sql,
                          # 003_add_platform_fee_settlements.sql
routes/v1/
  auth/{customer,merchant,terminal}/
  bottle-returns/       # config, coupons, credits, generate-tokens, iot/
  categories/, counters/, customers/, merchants/, orders/, payments/,
  products/, reports/, stocks/, stores/, subscriptions/, terminals/
test/                   # mirrors routes/ + repositories/ + services/
```

## customer/ — Jaspr SSR customer web store
```
lib/
  components/  cart/, drawers/, orders/, profile/, store/, layouts/, modals/
  config/api_client.dart
  models/cart_item.dart
  pages/       home, cart, orders, order_status, profile, store_detail,
               store_search, login, register, about
  services/    customer_cart_service.dart, store_detail_loader.dart
  signals/     cart, customer_auth, online_stores, recent_stores, toast
  utils/       cart_checkout_handler, customer_wallet_handler,
               phonepe_interop, customer_navigation
test/
```

## merchant/ — Jaspr SSR merchant portal
```
lib/
  components/  account/, auth/, dashboard/, modals/ (incl. subscription/),
               navigation/, reports/ (orders/products/payments/profit-loss/
               stock-summary tables), fields/
  config/api_client.dart
  models/nav_tab.dart
  pages/       home, login, register, forgot_password
  repositories/auth_repository.dart
  signals/     dashboard_*, orders, products, stores, terminals,
               subscription, platform_fee, bottle_return, categories,
               counters, payments, profit_loss, stock_summary
  sub_tabs/    categories, counters, orders, products, profit_loss,
               stock_summary
  tabs/        account, dashboard, stores
  utils/       chart_js, date_range_utils, payment_formatter,
               merchant_account_handler, phonepe_interop
test/
```

## terminal/ — Flutter POS app (Android/Linux/Windows)
```
lib/
  components/  billing/, cart/, inventory/ (categories/, counters/,
               products/, modals/, trina/ tables), orders/, navigation/,
               account/, auth/, product/, common/
  config/      api_client.dart, secure_storage.dart
  models/      cart_item.dart, cart_state.dart
  pages/       account, cart, home, inventory_{categories,counters,products},
               loading, login, orders
  repositories/terminal_repository.dart
  services/    terminal_checkout_handler.dart
  signals/     account, auth, cart, categories, counters, orders, products,
               inventory_*, bottle_return_*, navigation, router
  theme/       terminal_colors.dart
  utils/       responsive_extensions, terminal_toast
android/, linux/, windows/    # platform runners
test/
```

## packages/ — shared Dart packages
```
api_client/            # Dio wrapper, endpoints, exceptions, phonepe_interop
client_repositories/   # HTTP repos consumed by customer/merchant/terminal
models/                # freezed data models: order, product, customer,
                        # merchant, store, subscription, terminal, payment,
                        # bottle_return/*, profit_loss, stock, stock_summary
validators/            # request validation schemas per domain
```

## Other
```
landing/     # marketing site (Tailwind, static HTML)
tool/        # deploy.dart + src/ (builders, change_detector, deployer,
             # git_tagger, process_runner)
migrations/  # (see backend/migrations)
```

## Excluded from this map (generated/cache — never feed to an LLM)
`build/`, `node_modules/`, `.dart_tool/`, Android `app/build/`,
`*.g.dart`/`*.freezed.dart` generated files, `pubspec.lock`,
`package-lock.json`, `skills-lock.json`, `test_cache/`, platform build
artifacts (`.apk`, `.aar`, gradle intermediates).
