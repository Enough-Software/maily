import 'email_message.dart';
import 'mailbox_type.dart';

/// Abstract repository for email operations
abstract class EmailRepository {
  /// Fetches emails from a specific mailbox with pagination
  ///
  /// [mailboxType] - The mailbox to fetch from (inbox, sent, etc.)
  /// [page] - The page number (1-indexed)
  /// [pageSize] - Number of emails per page
  ///
  /// Returns a list of email messages
  /// Throws [EmailException] if fetch fails
  Future<List<EmailMessage>> fetchEmails({
    required MailboxType mailboxType,
    required int page,
    int pageSize = 20,
  });

  /// Fetches a single email by UID with full content
  ///
  /// Throws [EmailException] if fetch fails
  Future<EmailMessage> fetchEmailByUid({
    required MailboxType mailboxType,
    required int uid,
  });

  /// Marks an email as read
  ///
  /// Throws [EmailException] if operation fails
  Future<void> markAsRead({
    required MailboxType mailboxType,
    required int uid,
  });

  /// Marks an email as unread
  ///
  /// Throws [EmailException] if operation fails
  Future<void> markAsUnread({
    required MailboxType mailboxType,
    required int uid,
  });

  /// Deletes an email
  ///
  /// Throws [EmailException] if operation fails
  Future<void> deleteEmail({
    required MailboxType mailboxType,
    required int uid,
  });

  /// Gets the total count of emails in a mailbox
  ///
  /// Throws [EmailException] if operation fails
  Future<int> getEmailCount(MailboxType mailboxType);

  /// Connects to the email server
  Future<void> connect();

  /// Disconnects from the email server
  Future<void> disconnect();
}

/// Custom exception for email operations
class EmailException implements Exception {
  EmailException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'EmailException: $message${code != null ? ' (code: $code)' : ''}';
}
