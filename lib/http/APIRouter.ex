defmodule Freya.HTTP.APIRouter do
	import Ecto.Query

	use Plug.Router

	plug Plug.Parsers,
		parsers: [:urlencoded, :multipart],
		pass: ["*/*"]
	
	plug :match
  	plug :dispatch



	#plug :dispatch

	def randomString(length) do
		:crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
	end
	

	get "/" do
		send_resp(conn, 200, "Hello from router")
	end

	post "/create" do
		IO.inspect conn.params, label: "Photo upload information"

		upload = conn.params["file"]
	
		extension = Path.extname(upload.filename)

		IO.inspect File.read!(upload.path)

		fileString = randomString(16)

		filePath = Path.join(File.cwd!(), "js/#{upload.filename}-#{fileString}#{extension}")

  		File.cp(upload.path, filePath)

		lambda = %Freya.Lambda.Item{
			name: conn.params["name"],
			file: "js/#{upload.filename}-#{fileString}#{extension}",
			runFunction: conn.params["runFunction"]
		}

		Freya.Repo.insert(lambda)

		# uploadData = %Freya.HTTP.CreationParams{
		# 	conn.params
		# }

		# TODO: you can copy the uploaded file now,
		#       because it gets deleted after this request
		#json(conn, "Uploaded #{upload.photo.filename} to a temporary directory")
		send_resp(conn, 201, "Created")
	end

	get "/:lambdaName" do
		query = from l in Freya.Lambda.Item, where: l.name == ^lambdaName, select: l

		lambdaItem = Freya.Repo.one(query)

		IO.inspect lambdaItem

		filePath = Path.join(File.cwd!(), lambdaItem.file)
		
		result = 
			if (lambdaItem.runFunction) do
				NodeJS.call({filePath, lambdaItem.runFunction})
			else
				NodeJS.call(filePath)
			end
			
		IO.inspect result
		
		{ status, output } = result


		send_resp(conn, 200, output)
	end

	match _ do
		send_resp(conn, 404, "Oops!")
	  end
end