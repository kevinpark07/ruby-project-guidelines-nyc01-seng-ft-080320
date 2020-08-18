class CreateUserSpellsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :userspells do |t|
      t.belongs_to :user
      t.belongs_to :spell
    end
  end
end
