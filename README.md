# SmppexWeb

SmppexWeb is a simple demonstrational MC (SMPP server) with a simple web interface.
A public installation is available online at [smppex.rubybox.dev](http://smppex.rubybox.dev/).

## Requirements

- Elixir ~> 1.20
- Erlang/OTP ~> 29
- Node.js + npm

SmppexWeb does not use any external storage, keeping all session history in memory.

The web interface is built with server-rendered Phoenix templates, styled with
[TailwindCSS](https://tailwindcss.com/) + [DaisyUI](https://daisyui.com/) and made
interactive with [Alpine.js](https://alpinejs.dev/). Frontend dependencies are bundled
from `assets/` with npm, esbuild, and Tailwind CLI.

## Installation

To start SmppexWeb locally:

  * Install dependencies with `mix deps.get`
  * Install frontend dependencies with `npm install --prefix assets`
  * Build frontend assets with `npm run build --prefix assets`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

To establish an SMPP session, connect to `smppex.rubybox.dev:2775` (or `localhost:2775`
when running locally) and bind in any mode with any credentials.

## Production

Set `SECRET_KEY_BASE` and start the release:

```bash
export SECRET_KEY_BASE=$(mix phx.gen.secret)
export PHX_HOST=smppex.rubybox.dev
export PORT=8080
_build/prod/rel/main/bin/main start
```

## Docker

```bash
docker build -t smppex_web .
docker run -p 8080:8080 -p 2775:2775 -e SECRET_KEY_BASE=... smppex_web
```

## LICENSE

This software is licensed under [MIT License](LICENSE).
