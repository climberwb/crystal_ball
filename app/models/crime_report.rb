class CrimeReport < ActiveRecord::Base
  def self.check_crime(latitude, longitude)
    if crime_x.between?(latitude - 0.002, latitude + 0.002) && crime_y.between?(longitude - 0.002, longitude +0.002)
      # flash warning msg
    end
  end
end
