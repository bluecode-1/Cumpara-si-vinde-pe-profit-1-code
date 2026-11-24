import 'package:freezed_annotation/freezed_annotation.dart';

part 'money.freezed.dart';
part 'money.g.dart';

/// ISO 4217 currencies supported by the API.
@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum Currency { ron, eur }

/// An amount in minor units (bani / euro cents). Never a floating point value.
@freezed
abstract class Money with _$Money {
  const factory Money({required int amountMinor, required Currency currency}) =
      _Money;

  factory Money.fromJson(Map<String, dynamic> json) => _$MoneyFromJson(json);
}
