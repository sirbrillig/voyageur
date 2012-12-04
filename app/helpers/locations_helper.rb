module LocationsHelper
  def meters_to_miles(meters)
    miles_per_meter = 0.000621371
    (meters * miles_per_meter).round(1)
  end
end
