defprotocol FileSize.Calculable do
  def add(size, other_size)

  def add(size, other_size, as_unit)

  def subtract(size, other_size)

  def subtract(size, other_size, as_unit)
end
