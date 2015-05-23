class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.string :ip
      t.boolean :local_box

      t.timestamps null: false
    end

    add_index :boxes, :ip, unique: true
  end
end
