defmodule Freya.Lambda do
	defstruct name: "", runner: ""
	

	def new() do
		%Freya.Lambda{}
	end

	def run(%Freya.Lambda{name: name, runner: runner}) do
		#IO.
		IO.puts "Running lambda " <> name
	end
end