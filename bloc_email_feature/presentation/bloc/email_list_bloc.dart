import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/email_repository.dart';
import '../../domain/mailbox_type.dart';
import 'email_list_event.dart';
import 'email_list_state.dart';

/// BLoC for managing email list state and operations
class EmailListBloc extends Bloc<EmailListEvent, EmailListState> {
  EmailListBloc({
    required EmailRepository repository,
    required MailboxType mailboxType,
  })  : _repository = repository,
        _mailboxType = mailboxType,
        super(EmailListInitial(mailboxType)) {
    on<LoadEmailsEvent>(_onLoadEmails);
    on<LoadMoreEmailsEvent>(_onLoadMoreEmails);
    on<RefreshEmailsEvent>(_onRefreshEmails);
    on<MarkEmailAsReadEvent>(_onMarkAsRead);
    on<MarkEmailAsUnreadEvent>(_onMarkAsUnread);
    on<DeleteEmailEvent>(_onDeleteEmail);
    on<RetryEvent>(_onRetry);
  }

  final EmailRepository _repository;
  final MailboxType _mailboxType;
  static const int _pageSize = 20;

  /// Handles loading the first page of emails
  Future<void> _onLoadEmails(
    LoadEmailsEvent event,
    Emitter<EmailListState> emit,
  ) async {
    emit(EmailListLoading(_mailboxType));

    try {
      await _repository.connect();

      final emails = await _repository.fetchEmails(
        mailboxType: _mailboxType,
        page: 1,
        pageSize: _pageSize,
      );

      emit(EmailListLoaded(
        mailboxType: _mailboxType,
        messages: emails,
        currentPage: 2, // Next page to load
        hasMore: emails.length == _pageSize,
      ));
    } on EmailException catch (e) {
      emit(EmailListError(
        mailboxType: _mailboxType,
        error: e.message,
      ));
    } catch (e) {
      emit(EmailListError(
        mailboxType: _mailboxType,
        error: 'Đã xảy ra lỗi không xác định: $e',
      ));
    }
  }

  /// Handles loading more emails (pagination)
  Future<void> _onLoadMoreEmails(
    LoadMoreEmailsEvent event,
    Emitter<EmailListState> emit,
  ) async {
    // Prevent loading more if already loading or no more data
    if (state is EmailListLoadingMore || !state.hasMore) {
      return;
    }

    emit(EmailListLoadingMore(
      mailboxType: _mailboxType,
      messages: state.messages,
      currentPage: state.currentPage,
      hasMore: state.hasMore,
    ));

    try {
      final newEmails = await _repository.fetchEmails(
        mailboxType: _mailboxType,
        page: state.currentPage,
        pageSize: _pageSize,
      );

      emit(EmailListLoaded(
        mailboxType: _mailboxType,
        messages: [...state.messages, ...newEmails],
        currentPage: state.currentPage + 1,
        hasMore: newEmails.length == _pageSize,
      ));
    } on EmailException catch (e) {
      emit(EmailListActionFailure(
        mailboxType: _mailboxType,
        messages: state.messages,
        currentPage: state.currentPage,
        hasMore: state.hasMore,
        error: 'Không thể tải thêm email: ${e.message}',
      ));
    } catch (e) {
      emit(EmailListActionFailure(
        mailboxType: _mailboxType,
        messages: state.messages,
        currentPage: state.currentPage,
        hasMore: state.hasMore,
        error: 'Không thể tải thêm email: $e',
      ));
    }
  }

  /// Handles refreshing emails (pull-to-refresh)
  Future<void> _onRefreshEmails(
    RefreshEmailsEvent event,
    Emitter<EmailListState> emit,
  ) async {
    emit(EmailListRefreshing(
      mailboxType: _mailboxType,
      messages: state.messages,
    ));

    try {
      final emails = await _repository.fetchEmails(
        mailboxType: _mailboxType,
        page: 1,
        pageSize: _pageSize,
      );

      emit(EmailListLoaded(
        mailboxType: _mailboxType,
        messages: emails,
        currentPage: 2,
        hasMore: emails.length == _pageSize,
      ));
    } on EmailException catch (e) {
      emit(EmailListError(
        mailboxType: _mailboxType,
        error: 'Không thể làm mới: ${e.message}',
        messages: state.messages,
      ));
    } catch (e) {
      emit(EmailListError(
        mailboxType: _mailboxType,
        error: 'Không thể làm mới: $e',
        messages: state.messages,
      ));
    }
  }

  /// Handles marking an email as read
  Future<void> _onMarkAsRead(
    MarkEmailAsReadEvent event,
    Emitter<EmailListState> emit,
  ) async {
    try {
      await _repository.markAsRead(
        mailboxType: _mailboxType,
        uid: event.uid,
      );

      // Update local state
      final updatedMessages = state.messages.map((email) {
        if (email.uid == event.uid) {
          return email.copyWith(isRead: true);
        }
        return email;
      }).toList();

      emit(EmailListLoaded(
        mailboxType: _mailboxType,
        messages: updatedMessages,
        currentPage: state.currentPage,
        hasMore: state.hasMore,
      ));
    } on EmailException catch (e) {
      emit(EmailListActionFailure(
        mailboxType: _mailboxType,
        messages: state.messages,
        currentPage: state.currentPage,
        hasMore: state.hasMore,
        error: 'Không thể đánh dấu đã đọc: ${e.message}',
      ));
    } catch (e) {
      emit(EmailListActionFailure(
        mailboxType: _mailboxType,
        messages: state.messages,
        currentPage: state.currentPage,
        hasMore: state.hasMore,
        error: 'Không thể đánh dấu đã đọc: $e',
      ));
    }
  }

  /// Handles marking an email as unread
  Future<void> _onMarkAsUnread(
    MarkEmailAsUnreadEvent event,
    Emitter<EmailListState> emit,
  ) async {
    try {
      await _repository.markAsUnread(
        mailboxType: _mailboxType,
        uid: event.uid,
      );

      // Update local state
      final updatedMessages = state.messages.map((email) {
        if (email.uid == event.uid) {
          return email.copyWith(isRead: false);
        }
        return email;
      }).toList();

      emit(EmailListLoaded(
        mailboxType: _mailboxType,
        messages: updatedMessages,
        currentPage: state.currentPage,
        hasMore: state.hasMore,
      ));
    } on EmailException catch (e) {
      emit(EmailListActionFailure(
        mailboxType: _mailboxType,
        messages: state.messages,
        currentPage: state.currentPage,
        hasMore: state.hasMore,
        error: 'Không thể đánh dấu chưa đọc: ${e.message}',
      ));
    } catch (e) {
      emit(EmailListActionFailure(
        mailboxType: _mailboxType,
        messages: state.messages,
        currentPage: state.currentPage,
        hasMore: state.hasMore,
        error: 'Không thể đánh dấu chưa đọc: $e',
      ));
    }
  }

  /// Handles deleting an email
  Future<void> _onDeleteEmail(
    DeleteEmailEvent event,
    Emitter<EmailListState> emit,
  ) async {
    try {
      await _repository.deleteEmail(
        mailboxType: _mailboxType,
        uid: event.uid,
      );

      // Remove from local state
      final updatedMessages = state.messages
          .where((email) => email.uid != event.uid)
          .toList();

      emit(EmailListActionSuccess(
        mailboxType: _mailboxType,
        messages: updatedMessages,
        currentPage: state.currentPage,
        hasMore: state.hasMore,
        message: 'Đã xóa email',
      ));

      // Transition back to loaded state
      await Future.delayed(const Duration(milliseconds: 500));
      emit(EmailListLoaded(
        mailboxType: _mailboxType,
        messages: updatedMessages,
        currentPage: state.currentPage,
        hasMore: state.hasMore,
      ));
    } on EmailException catch (e) {
      emit(EmailListActionFailure(
        mailboxType: _mailboxType,
        messages: state.messages,
        currentPage: state.currentPage,
        hasMore: state.hasMore,
        error: 'Không thể xóa email: ${e.message}',
      ));
    } catch (e) {
      emit(EmailListActionFailure(
        mailboxType: _mailboxType,
        messages: state.messages,
        currentPage: state.currentPage,
        hasMore: state.hasMore,
        error: 'Không thể xóa email: $e',
      ));
    }
  }

  /// Handles retrying after an error
  Future<void> _onRetry(
    RetryEvent event,
    Emitter<EmailListState> emit,
  ) async {
    add(LoadEmailsEvent(_mailboxType));
  }

  @override
  Future<void> close() {
    _repository.disconnect();
    return super.close();
  }
}
