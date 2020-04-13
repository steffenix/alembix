defmodule Alembix do
  @moduledoc ~S"""

    ## Install

    In your `mix.exs` file add alembix to the release config


    ```
    defp releases do
      [
        api: [
          include_executables_for: [:unix],
          applications: [
            runtime_tools: :permanent,
            alembic: :permanent,
            api: :permanent
          ],
          runtime_config_path: "config/releases.exs",
        ]
      ]
    end
    ```

   ## Use

   In your release.exs file use Alembix to fetch variables.

   ```
   config :api, :server, Alembic.fetch_boolean!("START_SERVER")
   ```
  """

  @spec fetch_env!(String.t()) :: String.t() | :no_return
  def fetch_env!(name) do
    case System.get_env(name) do
      nil ->
        raise "Missing enviroment env variable #{name}"

      value ->
        value
    end
  end

  @spec fetch_boolean!(String.t()) :: boolean | :no_return
  def fetch_boolean!(name) do
    name
    |> fetch_env!()
    |> parse_boolean(name)
  end

  # sobelow_skip ["DOS.StringToAtom"]
  @spec fetch_atom!(String.t()) :: atom
  def fetch_atom!(name) do
    name
    |> fetch_env!()
    |> String.to_atom()
  end

  @spec fetch_integer!(String.t()) :: integer
  def fetch_integer!(name) do
    name
    |> fetch_env!()
    |> String.to_integer()
  end

  @spec fetch_base_16!(String.t()) :: binary
  def fetch_base_16!(name) do
    name
    |> fetch_env!()
    |> Base.decode16(case: :mixed)
    |> case do
      :error ->
        raise "Invalid base 16 enviroment env variable #{name}"

      {:ok, value} ->
        value
    end
  end

  defp parse_boolean("true", _), do: true
  defp parse_boolean("false", _), do: false
  defp parse_boolean(value, name), do: raise("Expected boolean for #{name} got #{value}")
end
