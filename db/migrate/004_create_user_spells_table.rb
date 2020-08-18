class CreateUserSpellsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :user_spells do |t|
      t.belongs_to :user
      t.belongs_to :spell
    end
  end
end
