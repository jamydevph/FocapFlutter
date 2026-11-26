import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_selection.freezed.dart';

@freezed
abstract class AppSelection with _$AppSelection {
  const factory AppSelection({
    required String packageName,
    required String label,
    required bool isBlocked,
    required int updatedAt,
  }) = _AppSelection;
}
