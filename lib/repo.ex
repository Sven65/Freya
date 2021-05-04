defmodule Freya.Repo do
	use Ecto.Repo, otp_app: :freya, adapter: Ecto.Adapters.SQLite3
end