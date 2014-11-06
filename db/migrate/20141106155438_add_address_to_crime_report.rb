class AddAddressToCrimeReport < ActiveRecord::Migration
  def change
    add_column :crime_reports, :address, :string
  end
end
