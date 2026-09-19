import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/remote_config.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            AppConstants.appName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppConstants.tagline,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Versión ${AppConstants.appVersionLabel}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          Text(
            'Aviso legal',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(AppConstants.disclaimer.trim()),
          const SizedBox(height: 24),
          Text(
            'Sesión',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'La sesión dura el día en que iniciaste sesión. Al día siguiente '
            'la app pedirá usuario y contraseña otra vez. También se cierra si '
            'pulsas «Cerrar sesión» o si el administrador revoca el acceso.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Text(
            'Enrolamiento del teléfono',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(AppConstants.enrollmentHelp.trim()),
          const SizedBox(height: 24),
          Text(
            'Actualización de datos',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            RemoteConfig.hasCatalogoUrl || RemoteConfig.hasUsuariosUrl
                ? 'Esta build puede actualizar catálogo y/o usuarios por red '
                    '(botón de sincronizar o al iniciar sesión). '
                    'Sin red sigue usando la última copia guardada en el teléfono.'
                : 'Esta build usa el catálogo y usuarios incluidos en el APK '
                    '(y la copia local si ya se actualizó antes). '
                    'Para sync remoto hay que compilar con URLs configuradas.',
            style: theme.textTheme.bodyMedium,
          ),
          if (RemoteConfig.hasCatalogoUrl) ...[
            const SizedBox(height: 8),
            Text(
              'Catálogo remoto: configurado',
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (RemoteConfig.hasUsuariosUrl) ...[
            Text(
              'Usuarios remoto: configurado',
              style: theme.textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 32),
          Text(
            'Colombia · Uso experimental · Solo Android',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
