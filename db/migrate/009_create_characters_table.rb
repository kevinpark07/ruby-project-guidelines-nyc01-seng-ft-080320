class CreateCharactersTable < ActiveRecord::Migration[6.0]
    def change
      create_table :characters do |t|
        t.belongs_to :scenario
        t.string :name
        t.string :house
        t.string :school
        t.string :bloodStatus
        t.boolean :deathEater
        t.boolean :dumbledoresArmy
        t.boolean :orderOfThePhoenix
        t.boolean :ministryOfMagic
      end
    end
  end