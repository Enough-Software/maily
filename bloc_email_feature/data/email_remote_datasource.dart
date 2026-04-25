import 'package:enough_mail/enough_mail.dart';
import '../domain/email_message.dart' as domain;
import '../domain/mailbox_type.dart';

/// Configuration for email connection
class EmailConfig {
  const EmailConfig({
    required this.serverHost,
    required this.serverPort,
    required this.username,
    required this.password,
    this.isSecure = true,
  });

  final String serverHost;
  final int serverPort;
  final String username;
  final String password;
  final bool isSecure;
}

/// Remote data source for email operations using IMAP
class EmailRemoteDataSource {
  EmailRemoteDataSource(this.config);

  final EmailConfig config;
  ImapClient? _client;

  /// Connects to the IMAP server
  Future<void> connect() async {
    if (_client != null && _client!.isLoggedIn) {
      return; // Already connected
    }

    _client = ImapClient(isLogEnabled: false);

    try {
      await _client!.connectToServer(
        config.serverHost,
        config.serverPort,
        isSecure: config.isSecure,
      );

      await _client!.login(config.username, config.password);
    } catch (e) {
      _client = null;
      rethrow;
    }
  }

  /// Disconnects from the IMAP server
  Future<void> disconnect() async {
    if (_client != null) {
      await _client!.logout();
      _client = null;
    }
  }

  /// Ensures connection is active
  Future<void> _ensureConnected() async {
    if (_client == null || !_client!.isLoggedIn) {
      await connect();
    }
  }

  /// Fetches emails from a specific mailbox with pagination
  Future<List<domain.EmailMessage>> fetchEmails({
    required MailboxType mailboxType,
    required int page,
    int pageSize = 20,
  }) async {
    await _ensureConnected();

    // Select the mailbox
    final selectResult = await _client!.selectMailbox(mailboxType.folderName);

    if (selectResult.messages == 0) {
      return [];
    }

    // Calculate the range for pagination
    // IMAP uses 1-based indexing, newest emails have highest sequence numbers
    final totalMessages = selectResult.messages;
    final endIndex = totalMessages - ((page - 1) * pageSize);
    final startIndex = (endIndex - pageSize + 1).clamp(1, totalMessages);

    if (endIndex < 1) {
      return [];
    }

    // Fetch email headers
    final fetchResult = await _client!.fetchMessages(
      MessageSequence.fromRange(startIndex, endIndex),
      'ENVELOPE FLAGS UID BODYSTRUCTURE',
    );

    // Convert to domain models
    return fetchResult.messages
        .map(_mapToDomainMessage)
        .toList()
        .reversed
        .toList(); // Reverse to show newest first
  }

  /// Gets the total count of emails in a mailbox
  Future<int> getEmailCount(MailboxType mailboxType) async {
    await _ensureConnected();
    final selectResult = await _client!.selectMailbox(mailboxType.folderName);
    return selectResult.messages;
  }

  /// Marks an email as read
  Future<void> markAsRead({
    required MailboxType mailboxType,
    required int uid,
  }) async {
    await _ensureConnected();
    await _client!.selectMailbox(mailboxType.folderName);
    await _client!.uidStore(
      MessageSequence.fromId(uid),
      [MessageFlags.seen],
      action: StoreAction.add,
    );
  }

  /// Marks an email as unread
  Future<void> markAsUnread({
    required MailboxType mailboxType,
    required int uid,
  }) async {
    await _ensureConnected();
    await _client!.selectMailbox(mailboxType.folderName);
    await _client!.uidStore(
      MessageSequence.fromId(uid),
      [MessageFlags.seen],
      action: StoreAction.remove,
    );
  }

  /// Deletes an email (moves to trash or marks as deleted)
  Future<void> deleteEmail({
    required MailboxType mailboxType,
    required int uid,
  }) async {
    await _ensureConnected();
    await _client!.selectMailbox(mailboxType.folderName);
    await _client!.uidStore(
      MessageSequence.fromId(uid),
      [MessageFlags.deleted],
      action: StoreAction.add,
    );
    await _client!.expunge();
  }

  /// Fetches a single email by UID with full content
  Future<domain.EmailMessage> fetchEmailByUid({
    required MailboxType mailboxType,
    required int uid,
  }) async {
    await _ensureConnected();
    await _client!.selectMailbox(mailboxType.folderName);

    final fetchResult = await _client!.uidFetchMessage(
      uid,
      'ENVELOPE FLAGS UID BODYSTRUCTURE BODY[]',
    );

    return _mapToDomainMessage(fetchResult);
  }

  /// Maps MimeMessage to domain EmailMessage
  domain.EmailMessage _mapToDomainMessage(MimeMessage mimeMessage) {
    final envelope = mimeMessage.envelope!;

    return domain.EmailMessage(
      uid: mimeMessage.uid!,
      subject: envelope.subject ?? '(No Subject)',
      from: domain.EmailAddress(
        email: envelope.from?.isNotEmpty == true
            ? envelope.from!.first.email
            : 'unknown@unknown.com',
        name: envelope.from?.isNotEmpty == true
            ? envelope.from!.first.personalName
            : null,
      ),
      to: envelope.to
              ?.map((addr) => domain.EmailAddress(
                    email: addr.email,
                    name: addr.personalName,
                  ))
              .toList() ??
          [],
      date: envelope.date ?? DateTime.now(),
      preview: _extractPreview(mimeMessage),
      body: mimeMessage.decodeTextPlainPart(),
      htmlBody: mimeMessage.decodeTextHtmlPart(),
      isRead: mimeMessage.flags?.contains(MessageFlags.seen) ?? false,
      isFlagged: mimeMessage.flags?.contains(MessageFlags.flagged) ?? false,
      hasAttachments: mimeMessage.hasAttachments(),
      size: mimeMessage.size,
      messageId: envelope.messageId,
    );
  }

  /// Extracts preview text from email body
  String? _extractPreview(MimeMessage mimeMessage) {
    try {
      final plainText = mimeMessage.decodeTextPlainPart();
      if (plainText != null && plainText.isNotEmpty) {
        // Return first 150 characters
        return plainText.length > 150
            ? '${plainText.substring(0, 150)}...'
            : plainText;
      }

      final htmlText = mimeMessage.decodeTextHtmlPart();
      if (htmlText != null && htmlText.isNotEmpty) {
        // Strip HTML tags and return first 150 characters
        final stripped = htmlText.replaceAll(RegExp(r'<[^>]*>'), '');
        return stripped.length > 150
            ? '${stripped.substring(0, 150)}...'
            : stripped;
      }
    } catch (e) {
      // Ignore errors in preview extraction
    }
    return null;
  }
}
