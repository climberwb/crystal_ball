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
    # 39.977102, -75.23310599999999
  end



  # GET /crime_reports/new
  def new
    # latitude = -75.1858
    # longitude = 39.9158


    @crime_report = CrimeReport.new
     geo_query = Geokit::Geocoders::GoogleGeocoder.geocode '1701 JFK BLVD., Philadelphia, PA' #need to be able to pull in address
    latitude = geo_query.ll.split(',')[0].to_f.round(4)
    longitude = geo_query.ll.split(',')[1].to_f.round(4)
    @lat = geo_query.ll.split(',')[0].to_f.round(4)
    @long = geo_query.ll.split(',')[1].to_f.round(4)
    base = "http://gis.phila.gov/ArcGIS/rest/services/PhilaGov/Police_Incidents/MapServer/0/query"
    uri = URI.parse "#{base}?where=DISPATCH_DATE%3D+%272014-10-30%27&text=&objectIds=&time=&geometry=&geometryType=esriGeometryPoint&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&outFields=*&returnGeometry=true&maxAllowableOffset=&geometryPrecision=&outSR=&returnIdsOnly=false&returnCountOnly=false&orderByFields=&groupByFieldsForStatistics=&outStatistics=&returnZ=false&returnM=false&gdbVersion=&returnDistinctValues=false&f=pjson"
    response = open(uri).read
    result = JSON.parse(response)
    @crimes = CrimeReport.check_crime(latitude, longitude, result)
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
