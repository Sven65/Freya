defmodule Freya.Repo.Migrations.CreateLambdas do
	use Ecto.Migration

	def change do
		create table(:lambda) do
			add :name, :string
			add :file, :string
			add :runFunction, :string
		end
	end
end
