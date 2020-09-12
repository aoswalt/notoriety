defmodule Notoriety.CLI do
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
