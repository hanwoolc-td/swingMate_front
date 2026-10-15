import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swingmate/core/config/app_config.dart';
import 'package:swingmate/core/network/auth_session.dart';
import 'package:swingmate/core/network/dio_provider.dart';
import 'package:swingmate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:swingmate/features/auth/data/repositories/dev_social_credential_source.dart';
import 'package:swingmate/features/auth/data/repositories/remote_auth_repository.dart';
import 'package:swingmate/features/auth/domain/repositories/auth_repository.dart';
import 'package:swingmate/features/auth/domain/repositories/social_credential_source.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => RemoteAuthRepository(
    AuthRemoteDataSource(ref.watch(dioProvider)),
    ref.watch(authSessionProvider),
  ),
);

final socialCredentialSourceProvider = Provider<SocialCredentialSource>(
  (ref) => ref.watch(appConfigProvider).isProduction
      ? const UnavailableSocialCredentialSource()
      : const DevSocialCredentialSource(),
);
