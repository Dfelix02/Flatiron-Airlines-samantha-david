class CreateFlights < ActiveRecord::Migration[5.2]
  def change
    create_table :flights do |t|
      t.datetime :date
      t.integer :destination_id
      t.datetime :departing_time
      t.datetime :arrival_time
    end
  end
end
