// lib/feature_flags.dart
import 'dart:io';
import 'package:openfeature_provider_intellitoggle/openfeature_provider_intellitoggle.dart';

class FeatureFlags {
  FeatureFlags._(this.provider, this.client);

  final IntelliToggleProvider provider;
  final IntelliToggleClient client;

  static Future<FeatureFlags> initialize() async {
    final provider = IntelliToggleProvider(
      clientId:     Platform.environment['INTELLITOGGLE_CLIENT_ID']!,
      clientSecret: Platform.environment['INTELLITOGGLE_CLIENT_SECRET']!,
      tenantId:     Platform.environment['INTELLITOGGLE_TENANT_ID']!,
      options: IntelliToggleOptions.production(
        baseUri: Uri.parse(
          Platform.environment['INTELLITOGGLE_API_URL']
              ?? 'https://api.intellitoggle.com',
        ),
      ),
    );

    await provider.initialize();
    await OpenFeatureAPI().setProvider(provider);

    final client = IntelliToggleClient(
      FeatureClient(
        metadata: ClientMetadata(name: 'targeting-rules-lab'),
        provider: provider,
        hookManager: HookManager(),
        defaultContext: EvaluationContext(attributes: {}),
      ),
    );

    return FeatureFlags._(provider, client);
  }

  Future<void> shutdown() => provider.shutdown();
}