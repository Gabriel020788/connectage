class AppConfig {
  // Projeto Supabase do ConectAge (Karine Org / sa-east-1).
  // A publishable key e a URL são dados públicos do cliente e podem ser
  // sobrescritos em builds futuros usando --dart-define.
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://bcctlrzbknzqctzyxtbn.supabase.co',
  );

  static const supabasePublishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_71qdzN4Iwr5lLpYPNcS0_Q_7-p6PCUx',
  );
}
