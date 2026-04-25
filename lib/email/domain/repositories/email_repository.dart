import '../models/email_message.dart';
import '../models/mailbox_type.dart';

/// Abstract repository for email operations
abstract class EmailRepository {
  /// Fetches emails from a specific mailbox with pagination
  ///
  /// [mailboxType] - The mailbox to fetch from (inbox, sent, etc.)
  /// [page] - The page number (1-indexed)
  /// [pageSize] - Number of emails per page
  ///
  /// Returns a list of email messages
  Future<List<EmailMessage>> fetchEmails({
    required MailboxType mailboxType,
    required int page,
    int pageSize = 20,
  });

  /// Fetches a single email by UID
  Future<EmailMessage> fetchEmailByUid({
    required MailboxType mailboxType,
    required int uid,
  });

  /// Marks an email as read
  Future<void> markAsRead({
    required MailboxType mailboxType,
    required int uid,
  });

  /// Marks an email as unread
  Future<void> markAsUnread({
    required MailboxType mailboxType,
    required int uid,
  });

  /// Deletes an email
  Future<void> deleteEmail({
    required MailboxType mailboxType,
    required int uid,
  });

  /// Gets the total count of emails in a mailbox
  Future<int> getEmailCount(MailboxType mailboxType);
}
