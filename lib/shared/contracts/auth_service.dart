import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String id;
  final String email;
  final String nickname;
  final bool isModerator;

  const UserProfile({
    required this.id,
    required this.email,
    required this.nickname,
    this.isModerator = false,
  });
}

abstract class AuthService {
  Future<UserProfile?> getCurrentUser();
  Future<bool> signIn(String email, String password);
  Future<void> signOut();
  Future<bool> signUp(String email, String password, String nickname);
}

class FakeAuthService implements AuthService {
  UserProfile? _currentUser = const UserProfile(
    id: 'user_1',
    email: 'cinephile@movietracker.com',
    nickname: 'CineMaster',
    isModerator: true,
  );

  @override
  Future<UserProfile?> getCurrentUser() async => _currentUser;

  @override
  Future<bool> signIn(String email, String password) async {
    if (email.isNotEmpty && password.length >= 8) {
      _currentUser = UserProfile(
        id: 'user_1',
        email: email,
        nickname: email.split('@')[0],
        isModerator: email.contains('mod'),
      );
      return true;
    }
    return false;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  @override
  Future<bool> signUp(String email, String password, String nickname) async {
    if (email.isNotEmpty && password.length >= 8 && nickname.isNotEmpty) {
      _currentUser = UserProfile(
        id: 'user_new',
        email: email,
        nickname: nickname,
        isModerator: false,
      );
      return true;
    }
    return false;
  }
}

final authServiceProvider = Provider<AuthService>((ref) => FakeAuthService());

final currentUserProvider = StateProvider<UserProfile?>((ref) {
  return const UserProfile(id: 'user_1', email: 'cinephile@movietracker.com', nickname: 'CineMaster', isModerator: true);
});
