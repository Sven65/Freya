defmodule Freya.HTTP.APIRouter do
	use Plug.Router

	plug Plug.Parsers,
		parsers: [:urlencoded, :multipart],
		pass: ["*/*"]
	
	plug :match
  	plug :dispatch



	#plug :dispatch

	

	get "/" do
		send_resp(conn, 200, "Hello from router")
	end

	post "/create" do
		IO.inspect conn, label: "Photo upload information"
		# TODO: you can copy the uploaded file now,
		#       because it gets deleted after this request
		#json(conn, "Uploaded #{upload.photo.filename} to a temporary directory")
		send_resp(conn, 400, "xd")
	end

	match _ do
		send_resp(conn, 404, "Oops!")
	  end
end