# require "#{ROOT}/models/validators/hasnt_paid_validator"

class Order < ActiveRecord::Base
  validates hasnt_paid: true

  belongs_to(:party)
  belongs_to(:food)

  def charge
    food = Food.where(:id => self.food_id)[0]
    if self.no_charge == true
      0
    else
      food.price.to_s[0..-3] + "." + food.price.to_s[-2..-1]
    end
  end

  def food_name
    Food.where(:id => self.food_id)[0].name
  end
end




