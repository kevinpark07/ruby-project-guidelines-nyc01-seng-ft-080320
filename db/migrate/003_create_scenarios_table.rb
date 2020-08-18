class CreateScenariosTable < ActiveRecord::Migration[6.0]
  def change
    create_table :scenarios do |t|
      t.string :name
    end
  end
end
