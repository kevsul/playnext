use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :playnext, PlaynextWeb.Endpoint,
  secret_key_base: "HaFYQmQMJK2Rs/u/JSFp5oCq7tjUK5YeqMVxjmmnxFnaSEhjsdg4PiDC9RdymCMC"

# Configure your database
config :playnext, Playnext.Repo,
  username: "postgres",
  password: "postgres",
  database: "playnext_prod",
  pool_size: 15
