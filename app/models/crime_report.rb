class CrimeReport < ActiveRecord::Base

  def self.check_crime(latitude, longitude, result)
    crime_events = []
    result.values_at("features").first.each do |obj|
      crime_x = obj.values_at("geometry").first.values_at("x").first.to_f.round(4)
      crime_y = obj.values_at("geometry").first.values_at("y").first.to_f.round(4)
      puts crime_x
      puts crime_y

      if crime_y.between?((latitude - 0.004), (latitude + 0.004)) && crime_x.between?((longitude - 0.004), (longitude + 0.004))
        puts "warning!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
         crime_events << obj
        puts crime_events
          puts "lat #{latitude} = #{crime_y}"
          puts "long #{longitude} = #{crime_x}"
        puts crime_events
      else

        puts "poop"
      end
    end
    crime_events

  end

end
