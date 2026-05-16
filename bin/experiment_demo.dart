void main() {
  final users = [
    {'id': 'user_001', 'variant': 'control'},
    {'id': 'user_002', 'variant': 'variant_a'},
    {'id': 'user_003', 'variant': 'variant_b'},
    {'id': 'user_004', 'variant': 'unknown'},
  ];

  print('=== Multivariate Experiment: onboarding-experiment ===\n');

  for (final user in users) {
    final variant = user['variant'];
    final flow = switch (variant) {
      'variant_a' => 'Simplified flow — 3 steps',
      'variant_b' => 'Product tour — 5 steps',
      _ => 'Standard flow — 7 steps (control)',
    };
    print('User ${user['id']} → Variant: $variant → $flow');
  }

  print('\n=== Experiment assignment complete ===');
}