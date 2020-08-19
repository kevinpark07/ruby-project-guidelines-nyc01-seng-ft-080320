class Character < ActiveRecord::Base
    has_many :user_characters
    has_many :users, through: :characters 

end