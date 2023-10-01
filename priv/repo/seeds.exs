# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Carpool.Repo.insert!(%Carpool.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Carpool.Accounts

user = %{
  firstname: "admin",
  lastname: "one",
  email: "admin@gmail.com",
  location: "thika",
  # In a real application, you'd hash the password
  password: "123456"
}

Accounts.register_user(user)
