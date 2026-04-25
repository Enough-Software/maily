import 'package:equatable/equatable.dart';

/// Represents an email message entity
class EmailMessage extends Equatable {
  const EmailMessage({
    required this.uid,
    required this.subject,
    required this.from,
    required this.to,
    required this.date,
    this.preview,
    this.body,
    this.htmlBody,
    this.isRead = false,
    this.isFlagged = false,
    this.hasAttachments = false,
    this.size,
    this.messageId,
  });

  final int uid;
  final String subject;
  final EmailAddress from;
  final List<EmailAddress> to;
  final DateTime date;
  final String? preview;
  final String? body;
  final String? htmlBody;
  final bool isRead;
  final bool isFlagged;
  final bool hasAttachments;
  final int? size;
  final String? messageId;

  EmailMessage copyWith({
    int? uid,
    String? subject,
    EmailAddress? from,
    List<EmailAddress>? to,
    DateTime? date,
    String? preview,
    String? body,
    String? htmlBody,
    bool? isRead,
    bool? isFlagged,
    bool? hasAttachments,
    int? size,
    String? messageId,
  }) {
    return EmailMessage(
      uid: uid ?? this.uid,
      subject: subject ?? this.subject,
      from: from ?? this.from,
      to: to ?? this.to,
      date: date ?? this.date,
      preview: preview ?? this.preview,
      body: body ?? this.body,
      htmlBody: htmlBody ?? this.htmlBody,
      isRead: isRead ?? this.isRead,
      isFlagged: isFlagged ?? this.isFlagged,
      hasAttachments: hasAttachments ?? this.hasAttachments,
      size: size ?? this.size,
      messageId: messageId ?? this.messageId,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        subject,
        from,
        to,
        date,
        preview,
        body,
        htmlBody,
        isRead,
        isFlagged,
        hasAttachments,
        size,
        messageId,
      ];
}

/// Represents an email address
class EmailAddress extends Equatable {
  const EmailAddress({
    required this.email,
    this.name,
  });

  final String email;
  final String? name;

  String get displayName => name ?? email;

  String get initials {
    if (name != null && name!.isNotEmpty) {
      final parts = name!.split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name![0].toUpperCase();
    }
    return email[0].toUpperCase();
  }

  @override
  List<Object?> get props => [email, name];
}
