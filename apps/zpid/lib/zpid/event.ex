defmodule Zpid.Event do
  @callback to_selectors(struct) :: any
  @type t :: struct
end
