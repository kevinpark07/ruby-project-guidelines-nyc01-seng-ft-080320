class UserSpell < ActiveRecord::Base
    belongs_to :user 
    belongs_to :spell

end