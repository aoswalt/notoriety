defmodule Notoriety.CLI do
  @moduledoc """
  Read any given options and call `Notoriety.generate_index/1` with the final
  options.

  ## Defaults

  The default options:
    * `:config_file` - `"notoriety.json"`
    * `:input_path` - `"notes/**/*.md"`
    * `:output_file` - `"index.md"`

  ## Environment Variables

  The default options may be overridden through environment variables.

  Allowed variables to their options:
    * `NOTO_CONFIG_FILE` - `:config_file`
    * `NOTO_INPUT_PATH` - `:input_path`
    * `NOTO_OUTPUT_FILE` - `:output_file`

  ## Arguments

  Options may be given directly as arguments.

  Arguments to their options:
    * `--config-file` - `:config_file`
    * `--input-path` - `:input_path`
    * `--output-file` - `:output_file`

  ## Configuration

  The input and output options may be defined in a configuration json file.

  Keys to their options:
    * `"config_file"` - `:config_file`
    * `"input_path"` - `:input_path`
    * `"output_file"` - `:output_file`

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
    opts = Keyword.merge(defaults(), env())
    arg_opts = parse_args(args)

    config_file_path = Keyword.get(arg_opts, :config_file) || Keyword.get(opts, :config_file)
    config_opts = parse_config(config_file_path)

    full_opts =
      opts
      |> Keyword.merge(config_opts)
      |> Keyword.merge(arg_opts)

    output_file = Keyword.fetch!(full_opts, :output_file)

    Notoriety.generate_index(full_opts)
    IO.puts("Generated #{output_file}")
  end

  defp defaults() do
    [
      config_file: "notoriety.json",
      input_path: "notes/**/*.md",
      output_file: "index.md"
    ]
  end

  defp env() do
    [
      config_file: System.get_env("NOTO_CONFIG_FILE"),
      input_path: System.get_env("NOTO_INPUT_PATH"),
      output_file: System.get_env("NOTO_OUTPUT_FILE")
    ]
    |> reject_nils()
  end

  defp parse_config(path) do
    json =
      case File.read(path) do
        {:ok, data} -> Jason.decode!(data)
        {:error, :enoent} -> %{}
      end

    [
      input_path: json["input_path"],
      output_file: json["output_file"]
    ]
    |> reject_nils()
  end

  defp parse_args(args) do
    {opts, _args, _invalid} =
      OptionParser.parse(args,
        strict: [config_file: :string, input_path: :string, output_file: :string]
      )

    opts
  end

  defp reject_nils(kw) do
    Enum.reject(kw, fn {_k, v} -> is_nil(v) end)
  end
end
