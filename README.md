# ConnectAge — TCC

Aplicativo Flutter acessível para organização da rotina, bem-estar e lembretes, com foco em pessoas idosas.

## V3 — identidade visual

A branch `v3` introduz a nova identidade do ConnectAge baseada na logo oficial do projeto.

- Azul principal: `#0B5DBB`
- Azul escuro: `#034F9E`
- Laranja principal: `#F57C00`
- Fundo claro: `#F7FAFE`
- Tipografia e componentes mantêm foco em legibilidade e acessibilidade
- Nova apresentação da logo no login, cadastro, início e perfil
- Login e cadastro redesenhados
- Tela inicial redesenhada
- Navegação inferior redesenhada
- Receitas, histórico e perfil redesenhados
- Cards, campos, botões e estados visuais padronizados pela nova identidade

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

Projeto Supabase: `ConnectAge` (`bcctlrzbknzqctzyxtbn`, região `sa-east-1`).

A migração da V2 cria `activity_history` e `trusted_contacts` com RLS e permanece compatível com a V3.

## Dependências principais

- `supabase_flutter`
- `alarm`
- `flutter_tts`
- `url_launcher`
- `permission_handler`
- `intl`

## Executar a V3

Para preservar as versões anteriores, use uma pasta separada:

```powershell
cd "C:\Users\karin\Documents\TCC BIEL\connectage"
git clone --branch v3 https://github.com/kroseno/connectage.git connectage-v3
cd connectage-v3
code .
flutter clean
flutter pub get
flutter run
```

Se a pasta `connectage-v3` já existir:

```powershell
git pull origin v3
flutter clean
flutter pub get
flutter run
```

## Assets

A V3 inclui a identidade visual do ConnectAge em `assets/branding/`. As imagens de hábitos e receitas continuam locais para manter o TCC simples, gratuito e funcional offline.
