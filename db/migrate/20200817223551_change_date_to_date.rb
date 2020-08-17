class ChangeDateToDate < ActiveRecord::Migration[5.2]
  def change
    change_column :flights, :date, :date
  end
end
