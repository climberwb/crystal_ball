class CrimeReport < ActiveRecord::Base
  def self.create_fence(latitude, longitude)
   @fence = []
   north = [latitude + 0.002, longitude]
   neast = [latitude + 0.0015, longitude + 0.0015]
   east = [latitude, longitude + 0.002]
   seast = [latitude - 0.0015, longitude + 0.0015]
   south = [latitude - 0.002, longitude]
   swest = [latitude - 0.0015, longitude - 0.0015]
   west = [latitude, longitude - 0.002]
   nwest = [latitude + 0.0015, longitude - 0.0015]

   @fence.push(north, neast, east, seast, south, swest, west, nwest, north)
 end
end
