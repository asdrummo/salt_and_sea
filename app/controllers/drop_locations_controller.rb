class DropLocationsController < ApplicationController
  before_filter :authenticate_admin
  
  # GET /drop_locations
  # GET /drop_locations.json
  def index
    @drop_locations = DropLocation.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @drop_locations }
    end
  end

  # GET /drop_locations/1
  # GET /drop_locations/1.json
  def show
    @drop_location = DropLocation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @drop_location }
    end
  end

  # GET /drop_locations/new
  # GET /drop_locations/new.json
  def new
    @drop_location = DropLocation.new
    @days = ['Monday', 'Tuesday', 'Wednesday','Thursday', 'Friday', 'Saturday', 'Sunday']
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @drop_location }
    end
  end

  # GET /drop_locations/1/edit
  def edit
    @drop_location = DropLocation.find(params[:id])
   
  end

  # POST /drop_locations
  # POST /drop_locations.json
  def create
    @drop_location = DropLocation.new(params[:drop_location])

    respond_to do |format|
      if @drop_location.save
        format.html { redirect_to @drop_location, notice: 'Drop location was successfully created.' }
        format.json { render json: @drop_location, status: :created, location: @drop_location }
      else
        format.html { render action: "new" }
        format.json { render json: @drop_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /drop_locations/1
  # PUT /drop_locations/1.json
  def update
    @drop_location = DropLocation.find(params[:id])

    respond_to do |format|
      if @drop_location.update_attributes(params[:drop_location])
        format.html { redirect_to @drop_location, notice: 'Drop location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @drop_location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drop_locations/1
  # DELETE /drop_locations/1.json
  def destroy
    @drop_location = DropLocation.find(params[:id])
    @drop_location.destroy

    respond_to do |format|
      format.html { redirect_to drop_locations_url }
      format.json { head :no_content }
    end
  end
end
