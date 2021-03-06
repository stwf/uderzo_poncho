defmodule Example do
  @moduledoc """
  This is a very minimal hello world Clixir example.
  """
  use Clixir

  # Include the header file indicated. This expands to a full
  # name of "c_src/example.hx"
  @clixir_header "example"

  @doc """
  Greet with the message.

  There will be an Elixir function in this module named `hello` that calls out
  to the generated C code to do the printf.
  """
  def_c hello(message) do
    cdecl "char *": message

    # Note that you don't want to send _anything_ to stdout, as that is the response
    # channel for our communication.
    fprintf(stderr, "Hello, %s!\n", message)
  end
end
