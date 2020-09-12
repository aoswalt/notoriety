import Config

case Mix.env() do
  :dev ->
    config :mix_test_watch,
      clear: true

  _ ->
    nil
end

case Mix.env() do
  :prod ->
    config :notoriety, :source, Notoriety.Source.FS

  _ ->
    config :notoriety, :source, Notoriety.Source.InMemory
end
