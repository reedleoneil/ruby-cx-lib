class Product
  attr_accessor :ProductId, :Product, :ProductFullName, :ProductType, :DecimalPlaces
  def initialize(product_id, product, product_full_name, product_type, decimal_places)
    @ProductId = product_id
    @Product = product
    @ProductFullName = product_full_name
    @ProductType = product_type
    @DecimalPlaces = decimal_places
  end
end
