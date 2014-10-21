class Party < ActiveRecord::Base
  has_many(:orders)
  has_many(:foods, :through => :orders)

  def food_names_for_receipt
    self.orders.map do |order|
      order.food_name.gsub(" ", "_").to_sym
    end
  end

end