import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/mailbox_type.dart';
import '../bloc/email_list_bloc.dart';
import '../bloc/email_list_event.dart';
import '../bloc/email_list_state.dart';
import 'email_list_item.dart';

/// Widget for displaying a scrollable list of emails with infinite scroll
class EmailListView extends StatefulWidget {
  const EmailListView({
    required this.mailboxType,
    super.key,
  });

  final MailboxType mailboxType;

  @override
  State<EmailListView> createState() => _EmailListViewState();
}

class _EmailListViewState extends State<EmailListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Handles scroll events for infinite scroll
  void _onScroll() {
    if (_isBottom) {
      context.read<EmailListBloc>().add(const LoadMoreEmailsEvent());
    }
  }

  /// Checks if scrolled to bottom (with 200px threshold)
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll - 200);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailListBloc, EmailListState>(
      listener: (context, state) {
        // Show snackbar for action success/failure
        if (state is EmailListActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is EmailListActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Đóng',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is EmailListLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EmailListError && state.messages.isEmpty) {
          return _buildErrorView(context, state.error!);
        }

        if (state.messages.isEmpty) {
          return _buildEmptyView(context);
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<EmailListBloc>().add(const RefreshEmailsEvent());
            // Wait for the refresh to complete
            await context.read<EmailListBloc>().stream.firstWhere(
                  (state) => state is! EmailListRefreshing,
                );
          },
          child: ListView.separated(
            controller: _scrollController,
            itemCount: state.messages.length + (state is EmailListLoadingMore ? 1 : 0),
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            itemBuilder: (context, index) {
              // Show loading indicator at the bottom
              if (index >= state.messages.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final email = state.messages[index];

              return EmailListItem(
                email: email,
                onTap: () {
                  // Mark as read when tapped
                  if (!email.isRead) {
                    context
                        .read<EmailListBloc>()
                        .add(MarkEmailAsReadEvent(email.uid));
                  }
                  // TODO: Navigate to email detail screen
                  _showEmailDetail(context, email);
                },
                onLongPress: () {
                  _showEmailOptions(context, email);
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mail_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Không có email',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Đã xảy ra lỗi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<EmailListBloc>().add(const RetryEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmailDetail(BuildContext context, email) {
    // TODO: Navigate to email detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mở email: ${email.subject}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showEmailOptions(BuildContext context, email) {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                email.isRead ? Icons.mark_email_unread : Icons.mark_email_read,
              ),
              title: Text(
                email.isRead ? 'Đánh dấu chưa đọc' : 'Đánh dấu đã đọc',
              ),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                if (email.isRead) {
                  context
                      .read<EmailListBloc>()
                      .add(MarkEmailAsUnreadEvent(email.uid));
                } else {
                  context
                      .read<EmailListBloc>()
                      .add(MarkEmailAsReadEvent(email.uid));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Xóa', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(bottomSheetContext);
                _confirmDelete(context, email);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, email) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa email "${email.subject}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<EmailListBloc>().add(DeleteEmailEvent(email.uid));
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
