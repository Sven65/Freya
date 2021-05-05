defmodule Freya.Util.NodeUtil do
	@moduledoc """
	NodeJS Utility functions for Freya
	"""

	@doc """
	Sets an environment variable in NodeJS

	## Parameters

		- name: The name of the environment variable to set

		- value: The value of the environment variable

	## Examples:

		iex> Freya.Util.NodeUtil.setEnv("MY_ENV_VAR", "My Value")
		
		{:ok, "OK"}
	"""
	def setEnv(name, value) do
		filePath = Path.join(File.cwd!(), "priv/js/env.js")
		NodeJS.call({filePath, :setEnv}, [name, value])
	end

	@doc """
	Removes an environment variable in NodeJS

	## Parameters

		- name: The name of the environment variable to remove

	## Examples:

		iex> Freya.Util.NodeUtil.removeEnv("MY_ENV_VAR")
		{:ok, "OK"}
	"""
	def removeEnv(name) do
		filePath = Path.join(File.cwd!(), "priv/js/env.js")
		NodeJS.call({filePath, :removeEnv}, [name])
	end
end