class Package < ApplicationRecord
  belongs_to :driver, class_name: 'User', optional: true
end
