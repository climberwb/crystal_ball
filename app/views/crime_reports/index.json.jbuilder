json.array!(@crime_reports) do |crime_report|
  json.extract! crime_report, :id
  json.url crime_report_url(crime_report, format: :json)
end
