class CreateSpellsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :spells do |t|
      t.string :spell_name
      t.string :effect_name
      t.string :category
    end
  end
end
