class ProcessedLocationsController < ApplicationController
  before_filter :authenticate_admin
  
  # GET /processed_locations
  # GET /processed_locations.json
  def index
    @processed_locations = ProcessedLocation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @processed_locations }
    end
  end

  # GET /processed_locations/1
  # GET /processed_locations/1.json
  def show
    @processed_location = ProcessedLocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @processed_location }
    end
  end

  # GET /processed_locations/new
  # GET /processed_locations/new.json
  def new
    @processed_location = ProcessedLocation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @processed_location }
    end
  end

  # GET /processed_locations/1/edit
  def edit
    @processed_location = ProcessedLocation.find(params[:id])
  end

  # POST /processed_locations
  # POST /processed_locations.json
  def create
    @processed_location = ProcessedLocation.new(params[:processed_location])

    respond_to do |format|
      if @processed_location.save
        format.html { redirect_to @processed_location, notice: 'Processed location was successfully created.' }
        format.json { render json: @processed_location, status: :created, location: @processed_location }
      else
        format.html { render action: "new" }
        format.json { render json: @processed_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /processed_locations/1
  # PUT /processed_locations/1.json
  def update
    @processed_location = ProcessedLocation.find(params[:id])

    respond_to do |format|
      if @processed_location.update_attributes(params[:processed_location])
        format.html { redirect_to @processed_location, notice: 'Processed location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @processed_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /processed_locations/1
  # DELETE /processed_locations/1.json
  def destroy
    @processed_location = ProcessedLocation.find(params[:id])
    @processed_location.destroy

    respond_to do |format|
      format.html { redirect_to processed_locations_url }
      format.json { head :no_content }
    end
  end
end
