class ChangeColumnTypes < ActiveRecord::Migration[5.2]
  def change
    change_column :flights, :arrival_time, :string
    change_column :flights, :departing_time, :string
  end
end
