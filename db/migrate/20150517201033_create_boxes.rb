class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.string :ip

      t.timestamps null: false
    end

    add_index :boxes, :ip, unique: true
  end
end
