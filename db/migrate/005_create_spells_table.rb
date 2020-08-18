class CreateSpellsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :spells do |t|
      t.string :spell
      t.string :effect
    end
  end
end
