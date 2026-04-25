import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/models/email_message.dart';

/// Widget for displaying a single email item in the list
class EmailListItem extends StatelessWidget {
  const EmailListItem({
    required this.email,
    this.onTap,
    this.onLongPress,
    super.key,
  });

  final EmailMessage email;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRead = email.isRead ?? false;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isRead ? null : theme.colorScheme.primaryContainer.withOpacity(0.1),
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              radius: 24,
              child: Text(
                _getInitials(email.from.name ?? email.from.email),
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Email content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sender name and date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          email.from.name ?? email.from.email,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(email.date),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Subject
                  Text(
                    email.subject,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),

                  // Preview
                  if (email.preview != null) ...[
                    Text(
                      email.preview!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Indicators
            const SizedBox(width: 8),
            Column(
              children: [
                if (email.isFlagged == true)
                  Icon(
                    Icons.star,
                    size: 16,
                    color: theme.colorScheme.secondary,
                  ),
                if (email.hasAttachments == true)
                  Icon(
                    Icons.attach_file,
                    size: 16,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';

    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '?';
    }

    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final emailDate = DateTime(date.year, date.month, date.day);

    if (emailDate == today) {
      return DateFormat.Hm().format(date); // e.g., "14:30"
    } else if (emailDate == yesterday) {
      return 'Hôm qua';
    } else if (now.difference(date).inDays < 7) {
      return DateFormat.E('vi_VN').format(date); // e.g., "T2" for Monday
    } else if (date.year == now.year) {
      return DateFormat.MMMd('vi_VN').format(date); // e.g., "Th1 15"
    } else {
      return DateFormat.yMMMd('vi_VN').format(date); // e.g., "15 Th1 2023"
    }
  }
}
