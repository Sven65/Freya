defmodule Freya.HTTP.APIRouter do
	@moduledoc """
	Handles requests for lambdas
	"""
	import Ecto.Query

	use Plug.Router

	plug Plug.Parsers,
		parsers: [:urlencoded, :multipart],
		pass: ["*/*"]
	
	plug :match
  	plug :dispatch


	@doc """
	Creates a random string with specified length
	"""
	def randomString(length) do
		:crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
	end

	@doc """
	Creates a lambda if it doesn't exist
	"""
	def createLambda(params) do
		lambdaName = params["name"]

		upload = params["file"]
	
		extension = Path.extname(upload.filename)

		fileString = randomString(16)

		filePath = Path.join(File.cwd!(), "js/#{upload.filename}-#{fileString}#{extension}")

  		File.cp(upload.path, filePath)

		lambda = %Freya.Lambda.Item{
			name: lambdaName,

			file: "js/#{upload.filename}-#{fileString}#{extension}",
			runFunction: params["runFunction"]
		}

		Freya.Repo.insert(lambda)

		{:ok, 201, "Created"}
	end

	@doc """
	Executes a lambda
	"""
	def executeLambda(lambda) do
		filePath = Path.join(File.cwd!(), lambda.file)
		
		result = 
			if (lambda.runFunction) do
				NodeJS.call({filePath, lambda.runFunction})
			else
				NodeJS.call(filePath)
			end
		
		{ status, output } = result

		cond do
			status == :error -> {:error, 500, output}
			status == :ok -> {:ok, 200, output}
		end
	end
	
	@doc """
	Deletes a lambda
	"""
	def deleteLambda(lambda) do
		filePath = Path.join(File.cwd!(), lambda.file)
		
		Freya.Repo.delete! lambda

		File.rm(filePath)

		{:ok, 200, "Removed lambda"}
	end

	get "/" do
		send_resp(conn, 200, "Hello from router")
	end

	post "/create" do
		lambdaName = conn.params["name"]

		query = from l in Freya.Lambda.Item, where: l.name == ^lambdaName, select: l

		lambdaItem = Freya.Repo.one(query)

		returnData = cond do 
			!is_nil(lambdaItem) -> {:error, 400, "Lambda already exists"}
			is_nil(lambdaItem) -> createLambda(conn.params)
		end

		{_status, httpCode, data} = returnData

		send_resp(conn, httpCode, data)
	end

	delete "/:lambdaName" do
		query = from l in Freya.Lambda.Item, where: l.name == ^lambdaName, select: l

		lambdaItem = Freya.Repo.one(query)

		result = cond do
			is_nil(lambdaItem) -> {:error, 404, "Lambda not found"}
			!is_nil(lambdaItem) -> deleteLambda(lambdaItem)
		end

		{_status, httpCode, output} = result

		send_resp(conn, httpCode, output)
	end

	get "/:lambdaName" do
		query = from l in Freya.Lambda.Item, where: l.name == ^lambdaName, select: l

		lambdaItem = Freya.Repo.one(query)

		result = cond do
			is_nil(lambdaItem) -> {:error, 404, "Lambda not found"}
			!is_nil(lambdaItem) -> executeLambda(lambdaItem)
		end

		{_status, httpCode, output} = result

		send_resp(conn, httpCode, output)
	end

	match _ do
		send_resp(conn, 404, "Oops!")
	  end
end