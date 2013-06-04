require 'test_helper'

class ProcessedLocationsControllerTest < ActionController::TestCase
  setup do
    @processed_location = processed_locations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:processed_locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create processed_location" do
    assert_difference('ProcessedLocation.count') do
      post :create, processed_location: { date: @processed_location.date, location_id: @processed_location.location_id }
    end

    assert_redirected_to processed_location_path(assigns(:processed_location))
  end

  test "should show processed_location" do
    get :show, id: @processed_location
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @processed_location
    assert_response :success
  end

  test "should update processed_location" do
    put :update, id: @processed_location, processed_location: { date: @processed_location.date, location_id: @processed_location.location_id }
    assert_redirected_to processed_location_path(assigns(:processed_location))
  end

  test "should destroy processed_location" do
    assert_difference('ProcessedLocation.count', -1) do
      delete :destroy, id: @processed_location
    end

    assert_redirected_to processed_locations_path
  end
end
