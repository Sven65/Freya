defmodule Freya.AppConfig do
	use Vapor.Planner

	@moduledoc """
	Freya application config
	"""

	dotenv()

	@doc """
	Basic application config
	"""
	config :http, env([
		{:invocationMethod, "INVOCATION_METHOD"},
		{:port, "HTTP_PORT", default: 4000},
	])
end