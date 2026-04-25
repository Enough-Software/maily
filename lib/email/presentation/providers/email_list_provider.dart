import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/email_message.dart';
import '../../domain/models/mailbox_type.dart';
import '../../domain/models/pagination_state.dart';
import 'email_repository_provider.dart';

part 'email_list_provider.g.dart';

/// Provider for email list with pagination
@riverpod
class EmailList extends _$EmailList {
  static const int _pageSize = 20;

  @override
  PaginationState build(MailboxType mailboxType) {
    // Auto-load first page on initialization
    Future.microtask(() => loadMore());
    return const PaginationState();
  }

  /// Loads more emails (pagination)
  Future<void> loadMore() async {
    // Prevent multiple simultaneous loads
    if (state.isLoading || !state.hasMore && state.currentPage > 1) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(emailRepositoryProvider);

      final newMessages = await repository.fetchEmails(
        mailboxType: mailboxType,
        page: state.currentPage,
        pageSize: _pageSize,
      );

      state = state.copyWith(
        messages: [...state.messages, ...newMessages],
        isLoading: false,
        hasMore: newMessages.length == _pageSize,
        currentPage: state.currentPage + 1,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refreshes the email list (pull-to-refresh)
  Future<void> refresh() async {
    state = const PaginationState(hasMore: true);
    await loadMore();
  }

  /// Marks an email as read locally and on server
  Future<void> markAsRead(int uid) async {
    try {
      final repository = ref.read(emailRepositoryProvider);
      await repository.markAsRead(mailboxType: mailboxType, uid: uid);

      // Update local state
      state = state.copyWith(
        messages: state.messages.map((msg) {
          if (msg.uid == uid) {
            return msg.copyWith(isRead: true);
          }
          return msg;
        }).toList(),
      );
    } catch (e) {
      // Handle error silently or show notification
      state = state.copyWith(error: 'Failed to mark as read: $e');
    }
  }

  /// Marks an email as unread locally and on server
  Future<void> markAsUnread(int uid) async {
    try {
      final repository = ref.read(emailRepositoryProvider);
      await repository.markAsUnread(mailboxType: mailboxType, uid: uid);

      // Update local state
      state = state.copyWith(
        messages: state.messages.map((msg) {
          if (msg.uid == uid) {
            return msg.copyWith(isRead: false);
          }
          return msg;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to mark as unread: $e');
    }
  }

  /// Deletes an email
  Future<void> deleteEmail(int uid) async {
    try {
      final repository = ref.read(emailRepositoryProvider);
      await repository.deleteEmail(mailboxType: mailboxType, uid: uid);

      // Remove from local state
      state = state.copyWith(
        messages: state.messages.where((msg) => msg.uid != uid).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to delete email: $e');
    }
  }
}

/// Provider for unread count
@riverpod
Future<int> unreadCount(UnreadCountRef ref, MailboxType mailboxType) async {
  final repository = ref.watch(emailRepositoryProvider);
  final emails =
      ref.watch(emailListProvider(mailboxType)).valueOrNull?.messages ?? [];

  // Count unread emails from current loaded messages
  return emails.where((email) => email.isRead == false).length;
}
