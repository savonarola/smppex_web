defmodule SmppexWeb.ChannelCase do
  @moduledoc """
  This module defines the test case to be used by
  channel tests.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ChannelTest

      @endpoint SmppexWeb.Endpoint
    end
  end

  setup _tags do
    :ok
  end
end
