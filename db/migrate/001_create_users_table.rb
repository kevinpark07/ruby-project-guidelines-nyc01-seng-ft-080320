class CreateUsersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :password
      t.belongs_to :game
      t.string :bloodStatus
      t.string :house
    end
  end
end