# Entrypoint for Freya

defmodule Freya do
	use Application


	@moduledoc """
	Documentation for `Freya`.
	"""

	@doc """
	Hello world.

	## Examples

			iex> Freya.main()
			:world

	"""
	def main do
		:world
	end

	def start(_, _) do
		IO.puts("start")
		# If values could not be found we raise an exception and halt the boot
		# process
		
		config = Vapor.load!([
			%Vapor.Provider.Dotenv{},
			%Vapor.Provider.Env{
				bindings: [
					{:invocationMethod, "INVOCATION_METHOD"}
				]
			}
		])

		IO.puts(config.invocationMethod)
		
		opts = [strategy: :one_for_one, name: Freya.Supervisor]

		jsPath = Path.join(File.cwd!(), "js")

		Supervisor.start_link([
			{NodeJS.Supervisor, [path: jsPath, pool_size: 4]}
		], opts)

		#supervisor(NodeJS, [[]])
	end

end
