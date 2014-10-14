class Selection < ActiveRecord::Base
  belongs_to(:party)
  belongs_to(:food)
end

