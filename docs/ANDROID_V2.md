# Android — ConnectAge V2

A V2 usa o pacote `alarm` para alarmes reais (som, vibração e tela cheia) e `flutter_tts` para leitura em voz alta.

## 1. Nome do aplicativo

Em `android/app/src/main/AndroidManifest.xml`, dentro de `<application>`, use:

```xml
android:label="ConnectAge"
```

## 2. Permissões necessárias

Dentro de `<manifest>`, antes de `<application>`, confirme estas permissões:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```

O app solicita em runtime as permissões de notificação, alarme exato e, no Android 14 ou superior, verifica a autorização especial de notificações em tela cheia.

## 3. Tela cheia no Android 14+

A partir do Android 14, declarar `USE_FULL_SCREEN_INTENT` no manifest não garante que o sistema permita abrir o alarme em tela cheia. O ConnectAge possui uma ponte nativa em `MainActivity.kt` que verifica `NotificationManager.canUseFullScreenIntent()`.

Se a permissão estiver bloqueada, o aplicativo abre automaticamente a página do sistema referente a notificações/intenções em tela cheia. O usuário deve permitir essa opção para que o alarme possa acender a tela e aparecer sobre a tela bloqueada.

A `MainActivity` também está configurada com `showWhenLocked` e `turnScreenOn` para suportar o comportamento de despertador.

## 4. Gradle

O pacote `alarm` requer minSdk 23 ou superior. O Flutter atual normalmente já atende esse requisito. Mantenha também `multiDexEnabled = true` no `defaultConfig`.

Depois de atualizar o projeto:

```powershell
flutter clean
flutter pub get
flutter run
```

## 5. Teste do alarme

1. Abra o ConnectAge e conceda as permissões solicitadas.
2. Se o Android abrir a tela de permissão de tela cheia, habilite a opção correspondente ao ConnectAge.
3. Crie um lembrete para 2 ou 3 minutos no futuro.
4. Coloque o app em segundo plano ou feche-o.
5. Bloqueie a tela e aguarde.

O alarme deve tocar, vibrar e abrir a interface de alarme sobre a tela bloqueada.

Quando o aparelho já está desbloqueado e sendo usado, versões recentes do Android podem optar por exibir uma notificação heads-up em vez de tomar a tela inteira. Esse comportamento é controlado pelo sistema operacional.

Em alguns fabricantes Android, otimizações agressivas de bateria ou bloqueio de início automático também podem limitar a abertura em tela cheia. Para a apresentação de TCC, teste previamente no aparelho que será utilizado.
