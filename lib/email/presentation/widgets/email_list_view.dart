import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/models/mailbox_type.dart';
import '../providers/email_list_provider.dart';
import 'email_list_item.dart';

/// Widget for displaying a scrollable list of emails with infinite scroll
class EmailListView extends HookConsumerWidget {
  const EmailListView({
    required this.mailboxType,
    super.key,
  });

  final MailboxType mailboxType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final emailListNotifier = ref.watch(emailListProvider(mailboxType).notifier);
    final emailState = ref.watch(emailListProvider(mailboxType));

    // Setup infinite scroll listener
    useEffect(
      () {
        void onScroll() {
          if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200) {
            // Load more when 200px from bottom
            emailListNotifier.loadMore();
          }
        }

        scrollController.addListener(onScroll);
        return () => scrollController.removeListener(onScroll);
      },
      [scrollController],
    );

    return RefreshIndicator(
      onRefresh: () => emailListNotifier.refresh(),
      child: emailState.messages.isEmpty && emailState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : emailState.messages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.mail_outline,
                        size: 64,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Không có email',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  controller: scrollController,
                  itemCount: emailState.messages.length +
                      (emailState.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Show loading indicator at the bottom
                    if (index == emailState.messages.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final email = emailState.messages[index];

                    return EmailListItem(
                      email: email,
                      onTap: () {
                        // Mark as read when tapped
                        if (email.isRead == false) {
                          emailListNotifier.markAsRead(email.uid);
                        }
                        // TODO: Navigate to email detail screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Open email: ${email.subject}'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      onLongPress: () {
                        _showEmailOptions(context, ref, email);
                      },
                    );
                  },
                ),
    );
  }

  void _showEmailOptions(BuildContext context, WidgetRef ref, email) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                email.isRead == true ? Icons.mark_email_unread : Icons.mark_email_read,
              ),
              title: Text(
                email.isRead == true ? 'Đánh dấu chưa đọc' : 'Đánh dấu đã đọc',
              ),
              onTap: () {
                Navigator.pop(context);
                if (email.isRead == true) {
                  ref
                      .read(emailListProvider(mailboxType).notifier)
                      .markAsUnread(email.uid);
                } else {
                  ref
                      .read(emailListProvider(mailboxType).notifier)
                      .markAsRead(email.uid);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Xóa', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, ref, email);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa email "${email.subject}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(emailListProvider(mailboxType).notifier)
                  .deleteEmail(email.uid);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa email')),
              );
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
