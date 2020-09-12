defmodule Notoriety.CLI do
  def main(_args \\ []) do
    Notoriety.generate_index()

    output_path = Application.get_env(:notoriety, :output_path)
    IO.puts("Generated #{output_path}")
  end
end
