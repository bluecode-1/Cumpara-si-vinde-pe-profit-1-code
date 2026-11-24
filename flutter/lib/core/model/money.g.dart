// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Money _$MoneyFromJson(Map<String, dynamic> json) => _Money(
  amountMinor: (json['amountMinor'] as num).toInt(),
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
);

Map<String, dynamic> _$MoneyToJson(_Money instance) => <String, dynamic>{
  'amountMinor': instance.amountMinor,
  'currency': _$CurrencyEnumMap[instance.currency]!,
};

const _$CurrencyEnumMap = {Currency.ron: 'RON', Currency.eur: 'EUR'};
