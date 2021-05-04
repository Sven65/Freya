defmodule Freya.Lambda.Item do
	use Ecto.Schema

	schema "lambda" do
		field :name, :string
		field :file, :string
		field :runFunction, :string
	end
end