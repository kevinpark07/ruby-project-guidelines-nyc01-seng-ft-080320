class CreateUserItemsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :user_items do |t|
      t.belongs_to :user
      t.belongs_to :item
    end
  end
end
