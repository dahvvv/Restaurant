# class HasntPaidValidator < ActiveModel::EachValidator
#   def validate_each(record, attribute, value = "")
#     unless value.paid != true
#       record.errors[attribute] << (options[:message] || "This table has paid already!  You need to open a new table to charge a new item.")
#     end
#   end
# end

