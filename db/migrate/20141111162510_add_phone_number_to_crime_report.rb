class AddPhoneNumberToCrimeReport < ActiveRecord::Migration
  def change
    add_column :crime_reports, :phonenumber, :string
  end
end
