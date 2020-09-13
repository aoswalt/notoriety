# Notoriety

Simple note management with markdown and tags.

---

Primary usage is through building the escript.

## Building the Escript

The escript may be built and installed with `MIX_ENV=prod mix do escript.build, escript.install`.

If you are using [asdf](https://asdf-vm.com) to manage your elixir version, run `asdf reshim elixir` to create shims for the new escript.

If your elixir is globally installed, make sure `~/.mix/escripts` is on your `PATH` so that any installed escripts are automatically available for use.

## Usage

By default, running the script finds all files matched by the pattern `notes/**/*.md`, builds an index of tags to their notes, and saves an index to `index.md`.

For more information and overriding the defaults, see the [CLI module](lib/notoriety/cli.ex).
