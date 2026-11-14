import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/contracts/auth_service.dart';
import '../../../shared/contracts/fake_data_source.dart';

class SignupProfilePage extends ConsumerStatefulWidget {
  final Map<String, String>? credentials;
  const SignupProfilePage({super.key, this.credentials});

  @override
  ConsumerState<SignupProfilePage> createState() => _SignupProfilePageState();
}

class _SignupProfilePageState extends ConsumerState<SignupProfilePage> {
  final _nicknameController = TextEditingController();
  String _selectedCountry = 'US';
  final Set<String> _selectedGenres = {};
  bool _isNicknameUnique = true;
  bool _checkingNickname = false;

  final List<String> _genres = ['Action', 'Sci-Fi', 'Drama', 'Thriller', 'Comedy', 'Romance', 'Animation', 'Horror'];

  Future<void> _checkNickname(String value) async {
    if (value.isEmpty) return;
    setState(() => _checkingNickname = true);
    final directory = ref.read(userDirectoryProvider);
    final unique = await directory.isNicknameUnique(value);
    setState(() {
      _isNicknameUnique = unique;
      _checkingNickname = false;
    });
  }

  void _finishSignup() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty || !_isNicknameUnique) return;

    final email = widget.credentials?['email'] ?? 'user@movietracker.com';
    final password = widget.credentials?['password'] ?? 'password123';

    final auth = ref.read(authServiceProvider);
    await auth.signUp(email, password, nickname);

    if (mounted) {
      context.go('/discover');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile Setup (Step 2/3)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(value: 0.66, color: colorScheme.primary),
            const SizedBox(height: 24),
            Center(
              child: Stack(
                children: [
                  CustomPaint(
                    painter: _DashedCirclePainter(color: colorScheme.primary),
                    child: const SizedBox(
                      width: 96,
                      height: 96,
                      child: Center(child: Icon(Icons.camera_alt, size: 36)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nicknameController,
              onChanged: _checkNickname,
              decoration: InputDecoration(
                labelText: 'Unique Nickname',
                suffixIcon: _checkingNickname
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Icon(_isNicknameUnique && _nicknameController.text.isNotEmpty ? Icons.check_circle : Icons.error,
                        color: _isNicknameUnique && _nicknameController.text.isNotEmpty ? colorScheme.primary : colorScheme.error),
                errorText: !_isNicknameUnique ? 'Nickname is already taken' : null,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCountry,
              dropdownColor: colorScheme.surface,
              decoration: const InputDecoration(labelText: 'Country'),
              items: const [
                DropdownMenuItem(value: 'US', child: Text('United States')),
                DropdownMenuItem(value: 'FR', child: Text('France')),
                DropdownMenuItem(value: 'CA', child: Text('Canada')),
                DropdownMenuItem(value: 'UK', child: Text('United Kingdom')),
              ],
              onChanged: (val) => setState(() => _selectedCountry = val ?? 'US'),
            ),
            const SizedBox(height: 16),
            Text('Favorite Genres', style: textTheme.headlineMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _genres.map((genre) {
                final selected = _selectedGenres.contains(genre);
                return FilterChip(
                  label: Text(genre),
                  selected: selected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _selectedGenres.add(genre);
                      } else {
                        _selectedGenres.remove(genre);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _finishSignup,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final Color color;
  _DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final radius = size.width / 2;
    final center = Offset(radius, radius);
    canvas.drawCircle(center, radius - 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
