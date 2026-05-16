import 'package:openfeature_provider_intellitoggle/openfeature_provider_intellitoggle.dart';
import 'package:test/test.dart';

void main() {
  late InMemoryProvider provider;

  setUp(() async {
    provider = InMemoryProvider();
    await provider.initialize();
    await OpenFeatureAPI().setProvider(provider);
  });

  tearDown(() async {
    await provider.shutdown();
  });

  test('enterprise user gets enterprise flag value', () async {
    provider.setFlag('enterprise-feature', true);

    final client = IntelliToggleClient(
      FeatureClient(
        metadata: ClientMetadata(name: 'test'),
        provider: provider,
        hookManager: HookManager(),
        defaultContext: EvaluationContext(attributes: {}),
      ),
    );

    final result = await client.getBooleanValue(
      'enterprise-feature',
      false,
      targetingKey: 'user_001',
      evaluationContext: {'plan': 'enterprise'},
    );

    expect(result, true);
  });

  test('free user gets false by default', () async {
    provider.setFlag('enterprise-feature', false);

    final client = IntelliToggleClient(
      FeatureClient(
        metadata: ClientMetadata(name: 'test'),
        provider: provider,
        hookManager: HookManager(),
        defaultContext: EvaluationContext(attributes: {}),
      ),
    );

    final result = await client.getBooleanValue(
      'enterprise-feature',
      false,
      targetingKey: 'user_002',
      evaluationContext: {'plan': 'free'},
    );

    expect(result, false);
  });
}