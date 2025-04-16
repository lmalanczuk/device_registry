class CreateDevices < ActiveRecord::Migration[7.1]
  def change
    create_table :devices do |t|
      t.string :serial_number

      t.timestamps
    end
  end
end
