class CreateCharactersTable < ActiveRecord::Migration[6.0]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :house
      t.string :bloodStatus
    end
  end
end
