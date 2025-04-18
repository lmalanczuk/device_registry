class AllowNullUserIdInDevices < ActiveRecord::Migration[7.1]
  def change
    change_column_null :devices, :user_id, true
  end
end
