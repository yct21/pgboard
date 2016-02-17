ExUnit.start(formatters: [ShouldI.CLIFormatter])

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(Pgzealot.Repo)
