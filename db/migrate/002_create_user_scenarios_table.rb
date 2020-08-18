class CreateUserScenariosTable < ActiveRecord::Migration[6.0]
  def change
    create_table :user_scenarios do |t|
      t.belongs_to :user
      t.belongs_to :scenario
    end
  end
end
