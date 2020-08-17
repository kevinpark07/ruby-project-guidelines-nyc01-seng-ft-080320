class Item < ActiveRecord::Base
has_many :user_items
has_many :users though: :user_items

end