class Food < ActiveRecord::Base
  validates :name, uniqueness: true

  has_many(:orders)
  has_many(:parties, :through => :orders)

  # def price_to_int
  #   # (self.price.to_f * 100).to_i
  #   self.update(:price => self.dollars.to_s + self.cents.to_s)
  # end

  def priceprint
    self.price.to_s[0..-3] + "." + self.price.to_s[-2..-1]
    # self.update(:price => :dollars.to_s + :cents.to_s)
  end

  # def order_id
  #   Order.where(:food_id => self.id).id
  # end
end

