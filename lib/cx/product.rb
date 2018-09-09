class Product
  attr_reader :product_id, :product, :product_full_name, :product_type, :decimal_places
  def initialize(product_id, product, product_full_name, product_type, decimal_places)
    @product_id = product_id
    @product = product
    @product_full_name = product_full_name
    @product_type = product_type
    @decimal_places = decimal_places
  end
end
