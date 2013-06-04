require 'test_helper'

class DropLocationsControllerTest < ActionController::TestCase
  setup do
    @drop_location = drop_locations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:drop_locations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create drop_location" do
    assert_difference('DropLocation.count') do
      post :create, drop_location: { address: @drop_location.address, day: @drop_location.day, link: @drop_location.link, name: @drop_location.name, time: @drop_location.time }
    end

    assert_redirected_to drop_location_path(assigns(:drop_location))
  end

  test "should show drop_location" do
    get :show, id: @drop_location
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @drop_location
    assert_response :success
  end

  test "should update drop_location" do
    put :update, id: @drop_location, drop_location: { address: @drop_location.address, day: @drop_location.day, link: @drop_location.link, name: @drop_location.name, time: @drop_location.time }
    assert_redirected_to drop_location_path(assigns(:drop_location))
  end

  test "should destroy drop_location" do
    assert_difference('DropLocation.count', -1) do
      delete :destroy, id: @drop_location
    end

    assert_redirected_to drop_locations_path
  end
end
