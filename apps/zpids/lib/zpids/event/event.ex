defmodule Zpids.Event do
  @callback to_selector(struct) :: any
  @type t :: struct
end
