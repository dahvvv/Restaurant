class Food < ActiveRecord::Base
  validates :name, uniqueness: true

  has_many(:orders)
  has_many(:parties, :through => :orders)

  def priceprint
    self.price.to_s[0..-3] + "." + self.price.to_s[-2..-1]
  end

  # def order_id
  #   Order.where(:food_id => self.id).id
  # end
end

