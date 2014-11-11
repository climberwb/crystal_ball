require 'twilio-ruby'

class CrimeReportsController < ApplicationController
  before_action :set_crime_report, only: [:show, :edit, :update, :destroy]
  require 'open-uri'
  require 'json'




  # GET /crime_reports
  # GET /crime_reports.json
  def index
    @crime_reports = CrimeReport.all
  end

  # GET /crime_reports/1
  # GET /crime_reports/1.json
  def show

    @address = CrimeReport.find(params[:id])
    geo_query = Geokit::Geocoders::GoogleGeocoder.geocode "#{@address.address}, Philadelphia, PA" #need to be able to pull in address
    latitude = geo_query.ll.split(',')[0].to_f.round(4)
    longitude = geo_query.ll.split(',')[1].to_f.round(4)
    @lat = geo_query.ll.split(',')[0].to_f.round(4)
    @long = geo_query.ll.split(',')[1].to_f.round(4)
    base = "http://gis.phila.gov/ArcGIS/rest/services/PhilaGov/Police_Incidents/MapServer/0/query"
    uri = URI.parse "#{base}?where=+DISPATCH_DATE%3D'2014-11-08'&text=&objectIds=&time=&geometry=&geometryType=esriGeometryPoint&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=*&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=&returnIdsOnly=false&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&f=pjson"
    response = open(uri).read
    result = JSON.parse(response)
    @crimes = CrimeReport.check_crime(latitude, longitude, result)

    @body = ""
    @crimes.each do |crime|
      @body = @body + "#{crime.values_at('attributes').first.values_at('TEXT_GENERAL_CODE').first}
                       #{crime.values_at('attributes').first.values_at('DISPATCH_TIME').first}
                       #{crime.values_at('attributes').first.values_at('LOCATION_BLOCK').first}         "
         # "#{crime.values_at('attributes').first.values_at('TEXT_GENERAL_CODE').first}

         #  #{crime.values_at('attributes').first.values_at('DISPATCH_TIME').first}

         #  #{crime.values_at('attributes').first.values_at('LOCATION_BLOCK').first}  "
    end
    # puts @body
    # put your own credentials here

         # set up a client to talk to the Twilio REST API
    if @body != ""
        @client = Twilio::REST::Client.new( account_sid,auth_token)

           @client.messages.create(
              from: '+12672457083',
              to: "+1#{@address.phonenumber}",
              body: "#{@body}",
        )
    end
  end

  # GET /crime_reports/new
  def new
    @crime_report = CrimeReport.new
  end

  # POST /crime_reports
  # POST /crime_reports.json
  def create
    @crime_report = CrimeReport.create(:address => params[:crime_report][:address], :phonenumber  => params[:crime_report][:phonenumber])

    if @crime_report.save
      redirect_to @crime_report
    else
      format.html { render :new }
      format.json { render json: @place.errors, status: :unprocessable_entity }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crime_report
      @crime_report = CrimeReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crime_report_params
      params[:crime_report]
    end
end
