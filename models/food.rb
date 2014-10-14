class Food < ActiveRecord::Base
  has_many(:selection.rb)
  has_many(:parties, :through => :selections)  
end

