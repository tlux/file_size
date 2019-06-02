defmodule FileSize.Size do
  @moduledoc """
  A behavior that defines how a to build a new file size.
  """

  @callback new(value :: number | Decimal.t()) :: FileSize.t()

  @callback new(
              value :: number | Decimal.t(),
              unit :: FileSize.unit() | UnitInfo.t()
            ) :: FileSize.t()
end
