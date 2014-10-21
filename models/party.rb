class Party < ActiveRecord::Base
  has_many(:orders)
  has_many(:foods, :through => :orders)

  def food_names_for_receipt
    self.orders.map do |order|
      order.food_name.gsub(" ", "_").to_sym
    end
  end

  def prices_for_receipt
    self.orders.map do |order|
      order.charge.to_f
    end
  end

  def total
    total = 0
    self.orders.each do |order|
      total += order.charge.to_f
    end
    "$#{total.round(2)}"
  end

end