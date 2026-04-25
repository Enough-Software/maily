import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/email_remote_datasource.dart';
import '../../data/repositories/email_repository_impl.dart';
import '../../domain/repositories/email_repository.dart';

part 'email_repository_provider.g.dart';

/// Provider for email configuration
@riverpod
EmailConfig emailConfig(EmailConfigRef ref) {
  // TODO: Get from user's account settings or secure storage
  // This is a placeholder - replace with actual account data
  return const EmailConfig(
    serverHost: 'mail.tuoitre.com.vn',
    serverPort: 993,
    username: 'your-email@tuoitre.com.vn',
    password: 'your-password',
  );
}

/// Provider for EmailRemoteDataSource
@riverpod
EmailRemoteDataSource emailRemoteDataSource(EmailRemoteDataSourceRef ref) {
  final config = ref.watch(emailConfigProvider);

  return EmailRemoteDataSource(
    serverHost: config.serverHost,
    serverPort: config.serverPort,
    username: config.username,
    password: config.password,
  );
}

/// Provider for EmailRepository
@riverpod
EmailRepository emailRepository(EmailRepositoryRef ref) {
  final dataSource = ref.watch(emailRemoteDataSourceProvider);
  final repository = EmailRepositoryImpl(dataSource);

  // Cleanup on dispose
  ref.onDispose(() async {
    await repository.dispose();
  });

  return repository;
}

/// Email configuration model
class EmailConfig {
  const EmailConfig({
    required this.serverHost,
    required this.serverPort,
    required this.username,
    required this.password,
  });

  final String serverHost;
  final int serverPort;
  final String username;
  final String password;
}
