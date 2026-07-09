defmodule SmppexWeb.Layouts do
  @moduledoc false

  use SmppexWeb, :html
  use SmppexWeb, :verified_routes

  embed_templates "layouts/*"
end
