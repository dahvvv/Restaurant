class Order < ActiveRecord::Base
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

  def self.list_for_chef
    self.where(:fired => false).order(id: :desc)
  end

end




