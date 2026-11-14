import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/contracts/auth_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _stayLoggedIn = true;
  String? _emailError;
  String? _passwordError;

  void _validateAndLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      _emailError = email.contains('@') && email.contains('.') ? null : 'Please enter a valid email';
      _passwordError = password.length >= 8 ? null : 'Password must be at least 8 characters';
    });

    if (_emailError == null && _passwordError == null) {
      final auth = ref.read(authServiceProvider);
      final success = await auth.signIn(email, password);
      if (!mounted) return;
      if (success) {
        context.go('/discover');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid credentials')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            Text('Welcome back to Movie Tracker', style: textTheme.headlineLarge, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailError,
                prefixIcon: Icon(Icons.email, color: colorScheme.primary),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _passwordError,
                prefixIcon: Icon(Icons.lock, color: colorScheme.primary),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: colorScheme.onSurfaceVariant),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Switch(
                  value: _stayLoggedIn,
                  onChanged: (val) => setState(() => _stayLoggedIn = val),
                ),
                const SizedBox(width: 8),
                Text('Stay logged in', style: textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _validateAndLogin,
              child: const Text('Sign in'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.go('/discover'),
              child: const Text('Explore without account'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.push('/forgot-password'),
              child: Text('Forgot password?', style: TextStyle(color: colorScheme.primary)),
            ),
            TextButton(
              onPressed: () => context.push('/signup'),
              child: Text('Create account', style: TextStyle(color: colorScheme.primary)),
            ),
          ],
        ),
      ),
    );
  }
}
