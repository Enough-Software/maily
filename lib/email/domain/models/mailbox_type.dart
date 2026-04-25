/// Enum representing different mailbox types
enum MailboxType {
  inbox('INBOX', 'Hộp thư đến'),
  sent('Sent', 'Thư đã gửi'),
  drafts('Drafts', 'Thư nháp'),
  trash('Trash', 'Thùng rác'),
  spam('Spam', 'Thư rác'),
  archive('Archive', 'Lưu trữ');

  const MailboxType(this.folderName, this.displayName);

  final String folderName;
  final String displayName;
}
