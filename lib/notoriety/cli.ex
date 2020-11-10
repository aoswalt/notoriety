defmodule Notoriety.CLI do
  @defaults [
    config_file: "notoriety.json",
    input_path: "notes/**/*.md",
    output_file: "index.md",
    template_file: :default
  ]

  @env_to_opts %{
    "NOTO_CONFIG_FILE" => :config_file,
    "NOTO_INPUT_PATH" => :input_path,
    "NOTO_OUTPUT_FILE" => :output_file,
    "NOTO_TEMPLATE_FILE" => :template_file
  }

  @args_to_opts %{
    "--config-file" => :config_file,
    "--input-path" => :input_path,
    "--output-file" => :output_file,
    "--template-file" => :template_file
  }

  @json_to_opts %{
    "input_path" => :input_path,
    "output_file" => :output_file,
    "template_file" => :template_file
  }

  @moduledoc """
  Read any given options and call `Notoriety.generate_index/1` with the final
  options.

  ## Defaults

  The default options:
  #{for {k, v} <- @defaults, into: "", do: ~s/* `#{k}` - `"#{v}"`\n/}

  ## Environment Variables

  The default options may be overridden through environment variables.

  Allowed variables to their options:
  #{for {k, v} <- @env_to_opts, into: "", do: ~s/* `#{k}` - `#{v}`\n/}

  ## Arguments

  Options may be given directly as arguments.

  Arguments to their options:
  #{for {k, v} <- @args_to_opts, into: "", do: ~s/* `#{k}` - `#{v}`\n/}

  ## Configuration

  The input and output options may be defined in a configuration json file.

  Keys to their options:
  #{for {k, v} <- @json_to_opts, into: "", do: ~s/* `"#{k}"` - `#{v}`\n/}

  ## Precedence

  In general the precedence is defaults < environment < config < arguments;
  however, the config file may be specified as an argument. Any other arguments
  override the values from the config file.
  """

  @doc """
  Read through any given options and call `Notoriety.generate_index/1` with the
  final set of options.
  """
  def main(args \\ []) do
    opts = Keyword.merge(@defaults, env())
    arg_opts = parse_args(args)

    config_file_path = Keyword.get(arg_opts, :config_file) || Keyword.get(opts, :config_file)
    config_opts = parse_config(config_file_path)

    full_opts =
      opts
      |> Keyword.merge(config_opts)
      |> Keyword.merge(arg_opts)

    {:ok, file_name, _content} = Notoriety.generate_index(full_opts)
    IO.puts("Generated #{file_name}")
  end

  defp env() do
    @env_to_opts
    |> Enum.map(fn {var, opt} -> {opt, System.get_env(var)} end)
    |> reject_nils()
  end

  defp parse_config(path) do
    json =
      case File.read(path) do
        {:ok, data} -> Jason.decode!(data)
        {:error, :enoent} -> %{}
      end

    @json_to_opts
    |> Enum.map(fn {key, opt} -> {opt, json[key]} end)
    |> reject_nils()
  end

  defp parse_args(args) do
    {opts, _args} =
      OptionParser.parse!(args,
        strict: Enum.map(@defaults, fn {k, _} -> {k, :string} end)
      )

    opts
  end

  defp reject_nils(kw) do
    Enum.reject(kw, fn {_k, v} -> is_nil(v) end)
  end
end
