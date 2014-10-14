class Party < ActiveRecord::Base
  has_many(:selections)
  has_many(:foods, :through => :selections)
end