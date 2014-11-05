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
  end

  # GET /crime_reports/new
  def new
    @crime_report = CrimeReport.new
    geo_query = Geokit::Geocoders::GoogleGeocoder.geocode '1701 JFK Blvd., Philadelphia, PA'
    @geo_show = Geokit::Geocoders::GoogleGeocoder.geocode '1701 JFK Blvd., Philadelphia, PA'
    latitude = geo_query.ll.split(',')[0].to_f
    longitude = geo_query.ll.split(',')[1].to_f
    coords = CrimeReport.create_fence(latitude, longitude)
    base = "http://gis.phila.gov/ArcGIS/rest/services/PhilaGov/Police_Incidents/MapServer/0/query"
   # base = "file:///Users/wkushn001c/Desktop/crime_committed.html.erb"
    params = URI.encode_www_form({
      geometry: coords,
      inSR: "yes",
      f: "pjson"
    })

    uri = URI.parse "#{base}?#{params}" #"http://gis.phila.gov/ArcGIS/rest/services/PhilaGov/Police_Incidents/MapServer/0/query?geometry={\"rings\":[#{coords}],\"spatialReference\":{\"wkid\":4326}}&geometryType=esriGeometryPolygon&spatialRel=esriSpatialRelContains&outFields=*&inSR=4326&outSR=4326&f=pjson&pretty=true"
    response = open(uri).read
    @result = JSON.parse(response)

    # @geo_coordinates = geo_query.ll.split(',')
    # @result = JSON.parse(open("http://crime.chicagotribune.com/api/1.0-beta1/crimeclassification/?format=json&limit=50").read)
  end
  # GET /crime_reports/1/edit
  def edit
  end

  # POST /crime_reports
  # POST /crime_reports.json
  def create
    @crime_report = CrimeReport.new(crime_report_params)
    result = JSON.parse(open("http://gis.phila.gov/ArcGIS/rest/services/PhilaGov/Police_Incidents/MapServer/0/query?text=&geometry=&geometryType=esriGeometryPoint&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&objectIds=&where=SECTOR%3D%273%27+AND+UCR_GENERAL%3D%27500%27&time=&returnCountOnly=false&returnIdsOnly=false&returnGeometry=true&maxAllowableOffset=&outSR=&outFields=*&f=pjson").read)
    respond_to do |format|
      if @crime_report.save
        format.html { redirect_to @crime_report, notice: 'Crime report was successfully created.' }
        format.json { render :show, status: :created, location: @crime_report }
      else
        format.html { render :new }
        format.json { render json: @crime_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crime_reports/1
  # PATCH/PUT /crime_reports/1.json
  def update
    respond_to do |format|
      if @crime_report.update(crime_report_params)
        format.html { redirect_to @crime_report, notice: 'Crime report was successfully updated.' }
        format.json { render :show, status: :ok, location: @crime_report }
      else
        format.html { render :edit }
        format.json { render json: @crime_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crime_reports/1
  # DELETE /crime_reports/1.json
  def destroy
    @crime_report.destroy
    respond_to do |format|
      format.html { redirect_to crime_reports_url, notice: 'Crime report was successfully destroyed.' }
      format.json { head :no_content }
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
