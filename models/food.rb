class Food < ActiveRecord::Base
  validates :name, uniqueness: true

  has_many(:orders)
  has_many(:parties, :through => :orders)

  def priceprint(price)
    price.to_s[0..-3] + "." + price.to_s[-2..-1]
  end
end

