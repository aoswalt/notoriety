import Config

case Mix.env() do
  :dev ->
    config :mix_test_watch,
      clear: true
  _ ->
    nil
end

config :notoriety, :source, Notoriety.Source.InMemory
