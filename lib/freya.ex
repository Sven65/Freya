# Entrypoint for Freya

defmodule Freya do
	use Application


	@moduledoc """
	Documentation for `Freya`.
	"""

	def start(_, _) do
		# config = Vapor.load!(Freya.AppConfig)

		# IO.puts("Port: " <> config.http.port)
		
		supervisorOpts = [strategy: :one_for_one, name: Freya.Supervisor]

		jsPath = Path.join(File.cwd!(), "js")

		supervisorChildren = [
			{NodeJS.Supervisor, [path: jsPath, pool_size: 4]},
			{Plug.Cowboy, scheme: :http, plug: Freya.HTTP.MyPlug, options: [port: 4001]},
		]

		Supervisor.start_link(supervisorChildren, supervisorOpts)
	end

end
