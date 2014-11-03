class CreateCrimeReports < ActiveRecord::Migration
  def change
    create_table :crime_reports do |t|

      t.timestamps
    end
  end
end
