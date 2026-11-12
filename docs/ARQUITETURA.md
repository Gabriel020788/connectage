# Arquitetura do ConectAge

## Escopo do TCC

Arquitetura propositalmente pequena:

```text
Flutter (Android)
      |
      +--> Supabase Auth
      |
      +--> Supabase PostgreSQL + RLS
      |
      +--> Notificações locais do aparelho
```

Não existe API própria, servidor dedicado, Docker, Kubernetes ou microsserviços.

## Entidades

### reminders
Lembretes de medicamento, consulta, água, caminhada e compromisso.

### tasks
Itens simples de tarefas ou compras.

## Segurança

O aplicativo usa a chave pública/publishable do Supabase e Row Level Security (RLS). As policies garantem que o usuário autenticado só consiga ler e alterar linhas em que `user_id = auth.uid()`.

## Recorrência no MVP

- `none`: lembrete único.
- `daily`: todos os dias no mesmo horário.

Recorrências mais complexas foram excluídas do MVP para reduzir risco no TCC.

## Notificações

O agendamento acontece localmente no aparelho. Para o MVP, o fuso está configurado como `America/Sao_Paulo`.
