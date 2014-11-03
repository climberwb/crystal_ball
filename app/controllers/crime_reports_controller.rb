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
    @result = JSON.parse(open("http://gis.phila.gov/ArcGIS/rest/services/PhilaGov/Police_Incidents/MapServer/0/query?text=&geometry=&geometryType=esriGeometryPoint&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&objectIds=&where=SECTOR%3D%273%27+AND+UCR_GENERAL%3D%27500%27&time=&returnCountOnly=false&returnIdsOnly=false&returnGeometry=true&maxAllowableOffset=&outSR=&outFields=*&f=pjson").read)

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
