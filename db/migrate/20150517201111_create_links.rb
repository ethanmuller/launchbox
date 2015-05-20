class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.belongs_to :box, index: true

      t.string :name
      t.string :url

      t.timestamps null: false
    end
  end
end
