import 'package:equatable/equatable.dart';
import '../../domain/email_message.dart';
import '../../domain/mailbox_type.dart';

/// Base class for all email list states
abstract class EmailListState extends Equatable {
  const EmailListState({
    required this.mailboxType,
    this.messages = const [],
    this.currentPage = 1,
    this.hasMore = true,
    this.error,
  });

  final MailboxType mailboxType;
  final List<EmailMessage> messages;
  final int currentPage;
  final bool hasMore;
  final String? error;

  @override
  List<Object?> get props => [mailboxType, messages, currentPage, hasMore, error];
}

/// Initial state - before any data is loaded
class EmailListInitial extends EmailListState {
  const EmailListInitial(MailboxType mailboxType)
      : super(mailboxType: mailboxType);
}

/// Loading state - fetching first page
class EmailListLoading extends EmailListState {
  const EmailListLoading(MailboxType mailboxType)
      : super(mailboxType: mailboxType);
}

/// Loading more state - fetching additional pages
class EmailListLoadingMore extends EmailListState {
  const EmailListLoadingMore({
    required MailboxType mailboxType,
    required List<EmailMessage> messages,
    required int currentPage,
    required bool hasMore,
  }) : super(
          mailboxType: mailboxType,
          messages: messages,
          currentPage: currentPage,
          hasMore: hasMore,
        );
}

/// Loaded state - data successfully fetched
class EmailListLoaded extends EmailListState {
  const EmailListLoaded({
    required MailboxType mailboxType,
    required List<EmailMessage> messages,
    required int currentPage,
    required bool hasMore,
  }) : super(
          mailboxType: mailboxType,
          messages: messages,
          currentPage: currentPage,
          hasMore: hasMore,
        );
}

/// Refreshing state - pull-to-refresh
class EmailListRefreshing extends EmailListState {
  const EmailListRefreshing({
    required MailboxType mailboxType,
    required List<EmailMessage> messages,
  }) : super(
          mailboxType: mailboxType,
          messages: messages,
        );
}

/// Error state - something went wrong
class EmailListError extends EmailListState {
  const EmailListError({
    required MailboxType mailboxType,
    required String error,
    List<EmailMessage> messages = const [],
    int currentPage = 1,
    bool hasMore = true,
  }) : super(
          mailboxType: mailboxType,
          messages: messages,
          currentPage: currentPage,
          hasMore: hasMore,
          error: error,
        );
}

/// Action success state - for operations like mark as read, delete
class EmailListActionSuccess extends EmailListState {
  const EmailListActionSuccess({
    required MailboxType mailboxType,
    required List<EmailMessage> messages,
    required int currentPage,
    required bool hasMore,
    required this.message,
  }) : super(
          mailboxType: mailboxType,
          messages: messages,
          currentPage: currentPage,
          hasMore: hasMore,
        );

  final String message;

  @override
  List<Object?> get props => [...super.props, message];
}

/// Action failure state - for operations that failed
class EmailListActionFailure extends EmailListState {
  const EmailListActionFailure({
    required MailboxType mailboxType,
    required List<EmailMessage> messages,
    required int currentPage,
    required bool hasMore,
    required String error,
  }) : super(
          mailboxType: mailboxType,
          messages: messages,
          currentPage: currentPage,
          hasMore: hasMore,
          error: error,
        );
}
