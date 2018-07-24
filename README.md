# Doro

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Developers

## Slack Transport

To connect the slack transport to your instance:

1.  Create an app at https://api.slack.com/apps, and attach it to your workspace.
2.  Under "Bot Users", click "Add a Bot User" and configure.
3.  Under "OAuth & Permissions", click "Install App to Workspace"
4.  Create a `config/dev.secret.exs` file if needed, and add the "Bot User OAuth Access Token" to it:
    ```elixir
    use Mix.Config

    config :doro,
      slack_api_key: "<Bot Access Token>"
    ```

## JS

### Lint

We have eslint and prettier installed.  Please use

```
yarn lint-fix
```

while in the assets directory to run `prettier` before checking stuff in.

