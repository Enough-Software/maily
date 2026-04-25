import 'package:freezed_annotation/freezed_annotation.dart';
import 'email_message.dart';

part 'pagination_state.freezed.dart';

/// Represents the state of paginated email list
@freezed
class PaginationState with _$PaginationState {
  const factory PaginationState({
    @Default([]) List<EmailMessage> messages,
    @Default(false) bool isLoading,
    @Default(false) bool hasMore,
    @Default(1) int currentPage,
    String? error,
  }) = _PaginationState;

  const PaginationState._();

  /// Check if this is the first page load
  bool get isFirstPage => currentPage == 1 && messages.isEmpty;

  /// Check if we're loading more (pagination)
  bool get isLoadingMore => isLoading && messages.isNotEmpty;
}
