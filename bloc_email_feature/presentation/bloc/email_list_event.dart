import 'package:equatable/equatable.dart';
import '../../domain/mailbox_type.dart';

/// Base class for all email list events
abstract class EmailListEvent extends Equatable {
  const EmailListEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load the first page of emails
class LoadEmailsEvent extends EmailListEvent {
  const LoadEmailsEvent(this.mailboxType);

  final MailboxType mailboxType;

  @override
  List<Object?> get props => [mailboxType];
}

/// Event to load more emails (pagination)
class LoadMoreEmailsEvent extends EmailListEvent {
  const LoadMoreEmailsEvent();
}

/// Event to refresh emails (pull-to-refresh)
class RefreshEmailsEvent extends EmailListEvent {
  const RefreshEmailsEvent();
}

/// Event to mark an email as read
class MarkEmailAsReadEvent extends EmailListEvent {
  const MarkEmailAsReadEvent(this.uid);

  final int uid;

  @override
  List<Object?> get props => [uid];
}

/// Event to mark an email as unread
class MarkEmailAsUnreadEvent extends EmailListEvent {
  const MarkEmailAsUnreadEvent(this.uid);

  final int uid;

  @override
  List<Object?> get props => [uid];
}

/// Event to delete an email
class DeleteEmailEvent extends EmailListEvent {
  const DeleteEmailEvent(this.uid);

  final int uid;

  @override
  List<Object?> get props => [uid];
}

/// Event to retry after an error
class RetryEvent extends EmailListEvent {
  const RetryEvent();
}
