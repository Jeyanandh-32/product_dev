// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terminal_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TerminalAccount _$TerminalAccountFromJson(Map<String, dynamic> json) =>
    _TerminalAccount(
      terminal: Terminal.fromJson(json['terminal'] as Map<String, dynamic>),
      store: json['store'] == null
          ? null
          : Store.fromJson(json['store'] as Map<String, dynamic>),
      merchant: json['merchant'] == null
          ? null
          : Merchant.fromJson(json['merchant'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TerminalAccountToJson(_TerminalAccount instance) =>
    <String, dynamic>{
      'terminal': instance.terminal,
      'store': instance.store,
      'merchant': instance.merchant,
    };
