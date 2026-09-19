import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants.dart';
import '../../data/auth_service.dart';
import '../../data/models/usuario.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.authService,
    required this.onLoggedIn,
  });

  final AuthService authService;
  final ValueChanged<Usuario> onLoggedIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usuarioCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _usuarioFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String? _error;
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _usuarioCtrl.dispose();
    _passwordCtrl.dispose();
    _usuarioFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    final result = await widget.authService.login(
      usuario: _usuarioCtrl.text,
      password: _passwordCtrl.text,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (result.isOk) {
      widget.onLoggedIn(result.usuario!);
    } else {
      setState(() => _error = AuthService.messageFor(result.failure!));
      _usuarioFocus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            Text(
              'Ingreso de agente',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.tagline,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Versión ${AppConstants.appVersionLabel}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextField(
                    controller: _usuarioCtrl,
                    focusNode: _usuarioFocus,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      hintText: 'ej. oscar',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    enabled: !_loading,
                    onTap: () {
                      if (!_usuarioFocus.hasFocus) {
                        _usuarioFocus.requestFocus();
                      }
                    },
                    onSubmitted: (_) => _passwordFocus.requestFocus(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _passwordCtrl,
                    focusNode: _passwordFocus,
                    obscureText: _obscure,
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(
                          _obscure ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    enabled: !_loading,
                  ),
                ],
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Material(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _error!,
                    style: TextStyle(color: theme.colorScheme.onErrorContainer),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Entrar'),
            ),
            const SizedBox(height: 32),
            _DeviceIdCard(authService: widget.authService),
            const SizedBox(height: 16),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                '¿Primera vez? Cómo enrolar el teléfono',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppConstants.enrollmentHelp.trim(),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Aviso legal'),
                    content: SingleChildScrollView(
                      child: Text(AppConstants.disclaimer.trim()),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Entendido'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Aviso legal'),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceIdCard extends StatefulWidget {
  const _DeviceIdCard({required this.authService});

  final AuthService authService;

  @override
  State<_DeviceIdCard> createState() => _DeviceIdCardState();
}

class _DeviceIdCardState extends State<_DeviceIdCard> {
  String? _deviceId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = await widget.authService.deviceId();
    if (!mounted) return;
    setState(() => _deviceId = id);
  }

  Future<void> _copy() async {
    final id = _deviceId;
    if (id == null) return;
    await Clipboard.setData(ClipboardData(text: id));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Código del teléfono copiado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Código de este teléfono',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sin este código registrado no podrás entrar. Cópialo y envíalo '
          'a quien administra la app.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            title: SelectableText(
              _deviceId ?? 'Generando…',
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
              ),
            ),
            trailing: IconButton(
              tooltip: 'Copiar',
              onPressed: _deviceId == null ? null : _copy,
              icon: const Icon(Icons.copy),
            ),
          ),
        ),
      ],
    );
  }
}
