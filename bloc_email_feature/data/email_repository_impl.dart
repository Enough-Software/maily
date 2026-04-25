import '../domain/email_message.dart';
import '../domain/email_repository.dart';
import '../domain/mailbox_type.dart';
import 'email_remote_datasource.dart';

/// Implementation of EmailRepository using IMAP
class EmailRepositoryImpl implements EmailRepository {
  EmailRepositoryImpl(this._remoteDataSource);

  final EmailRemoteDataSource _remoteDataSource;

  @override
  Future<void> connect() async {
    try {
      await _remoteDataSource.connect();
    } catch (e) {
      throw EmailException('Failed to connect to email server: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _remoteDataSource.disconnect();
    } catch (e) {
      throw EmailException('Failed to disconnect from email server: $e');
    }
  }

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
      throw EmailException(
        'Failed to fetch emails from ${mailboxType.displayName}: $e',
        code: 'FETCH_EMAILS_ERROR',
      );
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
      throw EmailException(
        'Failed to fetch email with UID $uid: $e',
        code: 'FETCH_EMAIL_ERROR',
      );
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
      throw EmailException(
        'Failed to mark email as read: $e',
        code: 'MARK_READ_ERROR',
      );
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
      throw EmailException(
        'Failed to mark email as unread: $e',
        code: 'MARK_UNREAD_ERROR',
      );
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
      throw EmailException(
        'Failed to delete email: $e',
        code: 'DELETE_EMAIL_ERROR',
      );
    }
  }

  @override
  Future<int> getEmailCount(MailboxType mailboxType) async {
    try {
      return await _remoteDataSource.getEmailCount(mailboxType);
    } catch (e) {
      throw EmailException(
        'Failed to get email count: $e',
        code: 'GET_COUNT_ERROR',
      );
    }
  }
}
