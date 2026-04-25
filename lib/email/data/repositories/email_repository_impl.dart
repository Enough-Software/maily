import '../../domain/models/email_message.dart';
import '../../domain/models/mailbox_type.dart';
import '../../domain/repositories/email_repository.dart';
import '../datasources/email_remote_datasource.dart';

/// Implementation of EmailRepository using IMAP
class EmailRepositoryImpl implements EmailRepository {
  EmailRepositoryImpl(this._remoteDataSource);

  final EmailRemoteDataSource _remoteDataSource;

  @override
  Future<List<EmailMessage>> fetchEmails({
    required MailboxType mailboxType,
    required int page,
    int pageSize = 20,
  }) async {
    try {
      return await _remoteDataSource.fetchEmails(
        mailboxType: mailboxType,
        page: page,
        pageSize: pageSize,
      );
    } catch (e) {
      throw EmailRepositoryException('Failed to fetch emails: $e');
    }
  }

  @override
  Future<EmailMessage> fetchEmailByUid({
    required MailboxType mailboxType,
    required int uid,
  }) async {
    try {
      return await _remoteDataSource.fetchEmailByUid(
        mailboxType: mailboxType,
        uid: uid,
      );
    } catch (e) {
      throw EmailRepositoryException('Failed to fetch email: $e');
    }
  }

  @override
  Future<void> markAsRead({
    required MailboxType mailboxType,
    required int uid,
  }) async {
    try {
      await _remoteDataSource.markAsRead(
        mailboxType: mailboxType,
        uid: uid,
      );
    } catch (e) {
      throw EmailRepositoryException('Failed to mark as read: $e');
    }
  }

  @override
  Future<void> markAsUnread({
    required MailboxType mailboxType,
    required int uid,
  }) async {
    try {
      await _remoteDataSource.markAsUnread(
        mailboxType: mailboxType,
        uid: uid,
      );
    } catch (e) {
      throw EmailRepositoryException('Failed to mark as unread: $e');
    }
  }

  @override
  Future<void> deleteEmail({
    required MailboxType mailboxType,
    required int uid,
  }) async {
    try {
      await _remoteDataSource.deleteEmail(
        mailboxType: mailboxType,
        uid: uid,
      );
    } catch (e) {
      throw EmailRepositoryException('Failed to delete email: $e');
    }
  }

  @override
  Future<int> getEmailCount(MailboxType mailboxType) async {
    try {
      return await _remoteDataSource.getEmailCount(mailboxType);
    } catch (e) {
      throw EmailRepositoryException('Failed to get email count: $e');
    }
  }

  /// Disposes resources
  Future<void> dispose() async {
    await _remoteDataSource.disconnect();
  }
}

/// Custom exception for repository errors
class EmailRepositoryException implements Exception {
  EmailRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
