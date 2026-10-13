import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swingmate/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:swingmate/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => MockAuthRepository(),
);
