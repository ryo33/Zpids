# Zpids

A game engine for fun.

## Features

- Creating game entities with small processes which handles events.
- All you need is Elixir to create your games.

## Dependencies

- Elixir 1.5.1
- Erlang 20
- C compiler (for Argon2)
- Node
- Postgres

## Environment Variables

- **GUARDIAN_SECRET_KEY**

## Development

1. Configure postgres parameters of `apps/zpids/config/dev.exs`
2. Run `mix deps.get`
3. Run `bash -c "cd apps/zpids_web/assets && npm install"`
3. Run `mix ecto.create`
4. Run `mix ecto.migrate`
5. Run `mix phx.server`
