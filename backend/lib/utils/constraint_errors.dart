import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';

/// Centralized mapping from database constraint violation names to
/// user-facing error messages.
///
/// Used in route-handler catch blocks to replace scattered
/// `e.toString().contains('constraint_name')` checks.
const _constraintMessages = <String, String>{
  // Merchants
  'merchants_email_key': 'Email already exists.',
  'merchants_whatsapp_number_key': 'Whatsapp Number already exists.',

  // Customers
  'customers_mobile_number_key': 'Mobile number is already registered.',

  // Stores
  'unique_merchant_store_name': 'You already have a store with this name.',

  // Categories
  'unique_store_category_name':
      'You already have a category with this name in this store.',

  // Counters
  'unique_store_counter_name':
      'You already have a counter with this name in this store.',

  // Products
  'unique_merchant_product_sku': 'You already have a product with this SKU.',
  'unique_store_product_name':
      'You already have a product with this name in this store.',

  // Terminals
  'unique_store_terminal_name':
      'You already have a terminal with this name in this store.',
  'terminals_pkey': 'Something went wrong. Please try again.',
};

/// Checks if [error] is a known database constraint violation and returns
/// a [badRequest] response with the mapped message. Returns `null` if the
/// error is not a recognized constraint violation.
Response? tryConstraintError(Object error) {
  final errorString = error.toString();
  for (final entry in _constraintMessages.entries) {
    if (errorString.contains(entry.key)) {
      return badRequest(message: entry.value);
    }
  }
  return null;
}
