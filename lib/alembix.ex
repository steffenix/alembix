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

  @spec fetch_env(String.t()) :: any
  @spec fetch_env(String.t(), any) :: any

  def fetch_env(name, default \\ nil), do: System.get_env(name) || default

  @spec fetch_env!(String.t()) :: String.t() | :no_return
  def fetch_env!(name) do
    case fetch_env(name) do
      nil ->
        raise "Missing enviroment env variable #{name}"

      value ->
        value
    end
  end

  @spec fetch_boolean(String.t()) :: boolean | nil
  @spec fetch_boolean(String.t(), any) :: boolean | nil
  def fetch_boolean(name, default \\ []) do
    name
    |> fetch_env(default)
    |> parse_boolean(name)
  end

  @spec fetch_boolean!(String.t()) :: boolean | :no_return
  def fetch_boolean!(name) do
    case fetch_boolean(name) do
      boolean when boolean in [true, false] -> boolean
      value -> raise("Expected boolean for #{name} got #{value}")
    end
  end

  # sobelow_skip ["DOS.StringToAtom"]
  @spec fetch_atom(String.t()) :: atom
  @spec fetch_atom(String.t(), any) :: atom
  def fetch_atom(name, default \\ nil) do
    case fetch_env(name, default) do
      value when is_atom(value) -> value
      value -> String.to_atom(value)
    end
  end

  # sobelow_skip ["DOS.StringToAtom"]
  @spec fetch_atom!(String.t()) :: atom | :no_return
  def fetch_atom!(name) do
    case fetch_atom(name) do
      nil -> raise "Missing enviroment env variable #{name}"
      value -> value
    end
  end

  @spec fetch_integer(String.t()) :: integer | nil
  def fetch_integer(name, default \\ nil) do
    case fetch_env(name, default) do
      nil -> nil
      value when is_integer(value) -> value
      value -> String.to_integer(value)
    end
  end

  @spec fetch_integer!(String.t()) :: integer
  def fetch_integer!(name) do
    case fetch_integer(name) do
      nil -> raise "Missing enviroment env variable #{name}"
      value -> value
    end
  end

  @spec fetch_base_16(String.t()) :: binary | nil
  def fetch_base_16(name, default \\ nil) do
    case fetch_env(name, default) do
      nil ->
        nil

      value ->
        value
        |> Base.decode16(case: :mixed)
        |> case do
          :error ->
            raise "Invalid base 16 enviroment env variable #{name}"

          {:ok, value} ->
            value
        end
    end
  end

  def fetch_base_16!(name) do
    case fetch_base_16(name) do
      nil -> raise "Missing enviroment env variable #{name}"
      value -> value
    end
  end

  defp parse_boolean("true", _), do: true
  defp parse_boolean("false", _), do: false
  defp parse_boolean(value, _) when is_boolean(value), do: value
  defp parse_boolean(_, _), do: nil
end
