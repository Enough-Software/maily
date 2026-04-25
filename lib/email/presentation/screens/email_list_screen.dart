import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/models/mailbox_type.dart';
import '../widgets/email_list_view.dart';

/// Main email screen with tabs for different mailboxes
class EmailListScreen extends HookConsumerWidget {
  const EmailListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Email'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Hộp thư đến',
                icon: Icon(Icons.inbox),
              ),
              Tab(
                text: 'Thư đã gửi',
                icon: Icon(Icons.send),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: Implement search
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tính năng tìm kiếm đang phát triển')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showMoreOptions(context);
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            EmailListView(mailboxType: MailboxType.inbox),
            EmailListView(mailboxType: MailboxType.sent),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO: Navigate to compose email screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Soạn email - chức năng đang phát triển')),
            );
          },
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Cài đặt'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cài đặt - đang phát triển')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('Thư mục khác'),
              onTap: () {
                Navigator.pop(context);
                _showOtherFolders(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sync),
              title: const Text('Đồng bộ'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đang đồng bộ...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showOtherFolders(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thư mục khác'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.drafts),
              title: Text(MailboxType.drafts.displayName),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to drafts folder
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: Text(MailboxType.trash.displayName),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to trash folder
              },
            ),
            ListTile(
              leading: const Icon(Icons.report),
              title: Text(MailboxType.spam.displayName),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to spam folder
              },
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: Text(MailboxType.archive.displayName),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to archive folder
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
