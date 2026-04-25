import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_message.freezed.dart';
part 'email_message.g.dart';

/// Represents an email message
@freezed
class EmailMessage with _$EmailMessage {
  const factory EmailMessage({
    required int uid,
    required String subject,
    required EmailAddress from,
    required List<EmailAddress> to,
    required DateTime date,
    String? preview,
    bool? isRead,
    bool? isFlagged,
    bool? hasAttachments,
    int? size,
    String? messageId,
  }) = _EmailMessage;

  factory EmailMessage.fromJson(Map<String, dynamic> json) =>
      _$EmailMessageFromJson(json);
}

/// Represents an email address
@freezed
class EmailAddress with _$EmailAddress {
  const factory EmailAddress({
    required String email,
    String? name,
  }) = _EmailAddress;

  factory EmailAddress.fromJson(Map<String, dynamic> json) =>
      _$EmailAddressFromJson(json);
}
