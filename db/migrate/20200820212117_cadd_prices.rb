class CaddPrices < ActiveRecord::Migration[5.2]
  def change
    add_column :flights, :price, :float
  end
end
