class RemovePhoneNumberFromCrimeReport < ActiveRecord::Migration
  def change
    remove_column :crime_reports, :phonenumber, :integer
  end
end
