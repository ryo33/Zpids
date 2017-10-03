defmodule Zpids.ID do
  def gen do
    UUID.uuid4()
  end
end
