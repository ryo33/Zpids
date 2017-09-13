defmodule Zpid.ID do
  def gen do
    UUID.uuid4()
  end
end
