import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../l10n/gen/app_localizations.dart';
import 'auth_repository.dart';

/// Onboarding step 1: Apple / Google / email magic link.
class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _sentTo;
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    super.dispose();
  }

  /// Runs [action] with the buttons disabled; true if it succeeded.
  Future<bool> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
      return true;
    } on AuthException catch (e) {
      _showError(e.message);
      return false;
    } catch (e) {
      if (mounted) _showError(AppLocalizations.of(context).genericError);
      return false;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _sendLink() async {
    if (!_formKey.currentState!.validate()) return;
    final email = _email.text.trim();
    final sent = await _run(
      () => ref.read(authRepositoryProvider).sendMagicLink(email),
    );
    if (sent && mounted) setState(() => _sentTo = email);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final auth = ref.read(authRepositoryProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.appName,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontFamily: 'Fraunces',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.signInTagline,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 40),
                    FilledButton.icon(
                      onPressed: _busy
                          ? null
                          : () => _run(auth.signInWithApple),
                      icon: const Icon(Icons.apple),
                      label: Text(l10n.signInWithApple),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () => _run(auth.signInWithGoogle),
                      icon: const Icon(Icons.g_mobiledata, size: 28),
                      label: Text(l10n.signInWithGoogle),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(l10n.signInOr),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_sentTo == null) ...[
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.send,
                        onFieldSubmitted: (_) => _sendLink(),
                        decoration: InputDecoration(
                          labelText: l10n.signInEmailLabel,
                          border: const OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v != null &&
                                RegExp(r'^\S+@\S+\.\S+$').hasMatch(v.trim())
                            ? null
                            : l10n.signInEmailInvalid,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.tonal(
                        onPressed: _busy ? null : _sendLink,
                        child: Text(l10n.signInSendLink),
                      ),
                    ] else ...[
                      Text(
                        l10n.signInCheckInbox(_sentTo!),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _code,
                        keyboardType: TextInputType.number,
                        autofillHints: const [AutofillHints.oneTimeCode],
                        decoration: InputDecoration(
                          labelText: l10n.signInCodeLabel,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.tonal(
                        onPressed: _busy
                            ? null
                            : () => _run(
                                () =>
                                    auth.verifyEmailCode(_sentTo!, _code.text),
                              ),
                        child: Text(l10n.signInVerifyCode),
                      ),
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () => setState(() => _sentTo = null),
                        child: Text(l10n.signInUseDifferentEmail),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
