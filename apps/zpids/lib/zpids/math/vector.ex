defmodule Zpids.Math.Vector do
  def rotate({x, y}, radian) do
    cos = :math.cos(radian)
    sin = :math.sin(radian)
    rx = cos * x - sin * y
    ry = sin * x + cos * y
    {rx, ry}
  end
end
