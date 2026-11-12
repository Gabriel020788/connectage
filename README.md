# ConnectAge — TCC

Aplicativo Flutter acessível para organização da rotina, bem-estar e lembretes, com foco em pessoas idosas.

## V3 — identidade visual

Este repositório hospeda a versão V3 do ConnectAge.

- Azul principal: `#0B5DBB`
- Azul escuro: `#034F9E`
- Laranja principal: `#F57C00`
- Fundo claro: `#F7FAFE`
- Tipografia e componentes com foco em legibilidade e acessibilidade
- Login e cadastro redesenhados
- Tela inicial redesenhada
- Navegação inferior redesenhada
- Receitas, histórico e perfil redesenhados
- Cards, campos, botões e estados visuais padronizados pela identidade do projeto

Versão atual da V3: `0.3.0+8`.

## Funcionalidades

- Cadastro/login com data de nascimento
- Perfil editável (nome, nascimento e senha)
- Lembretes de medicamentos, consultas, hidratação, caminhada e compromissos
- Alarmes com som, vibração, tela cheia e opção **Adiar 10 minutos**
- Leitura em voz alta usando TTS
- Tarefas e compras
- Histórico de atividades concluídas
- Pessoa de confiança: ligar, WhatsApp e mensagem
- Sugestões de hábitos saudáveis por faixa etária
- 10 receitas locais com imagens
- Supabase Auth + PostgreSQL + RLS

## Backend

Projeto Supabase: `ConnectAge` (região `sa-east-1`).

O banco utiliza PostgreSQL, autenticação pelo Supabase Auth e Row Level Security (RLS) para isolamento dos dados por usuário.

## Dependências principais

- `supabase_flutter`
- `alarm`
- `flutter_tts`
- `url_launcher`
- `permission_handler`
- `intl`

## Executar o projeto

```powershell
git clone https://github.com/Gabriel020788/connectage.git
cd connectage
flutter clean
flutter pub get
flutter run
```

Também existe a branch `v3`, mantida como referência da versão apresentada no TCC.

## Gerar APK

```powershell
flutter build apk --release
```

O APK será gerado em:

```text
build\app\outputs\flutter-apk\app-release.apk
```

## Assets

A identidade visual está em `assets/branding/`. As imagens de hábitos e receitas utilizadas pela V3 permanecem locais para manter o projeto simples e sem dependência de API externa para esses conteúdos.
