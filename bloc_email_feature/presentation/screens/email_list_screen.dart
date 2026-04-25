import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/email_remote_datasource.dart';
import '../../data/email_repository_impl.dart';
import '../../domain/email_repository.dart';
import '../../domain/mailbox_type.dart';
import '../bloc/email_list_bloc.dart';
import '../bloc/email_list_event.dart';
import '../widgets/email_list_view.dart';

/// Main email screen with tabs for different mailboxes
class EmailListScreen extends StatelessWidget {
  const EmailListScreen({
    required this.emailConfig,
    super.key,
  });

  final EmailConfig emailConfig;

  @override
  Widget build(BuildContext context) {
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
                _showSearchDialog(context);
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
        body: TabBarView(
          children: [
            _buildEmailListTab(context, MailboxType.inbox),
            _buildEmailListTab(context, MailboxType.sent),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showComposeEmail(context);
          },
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }

  /// Builds a tab with email list
  Widget _buildEmailListTab(BuildContext context, MailboxType mailboxType) {
    return BlocProvider(
      create: (context) {
        final repository = _createRepository();
        final bloc = EmailListBloc(
          repository: repository,
          mailboxType: mailboxType,
        );
        // Load emails immediately
        bloc.add(LoadEmailsEvent(mailboxType));
        return bloc;
      },
      child: EmailListView(mailboxType: mailboxType),
    );
  }

  /// Creates email repository instance
  EmailRepository _createRepository() {
    final dataSource = EmailRemoteDataSource(emailConfig);
    return EmailRepositoryImpl(dataSource);
  }

  void _showSearchDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng tìm kiếm đang phát triển')),
    );
  }

  void _showComposeEmail(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Soạn email - chức năng đang phát triển')),
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
