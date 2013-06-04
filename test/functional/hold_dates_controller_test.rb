require 'test_helper'

class HoldDatesControllerTest < ActionController::TestCase
  setup do
    @hold_date = hold_dates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hold_dates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hold_date" do
    assert_difference('HoldDate.count') do
      post :create, hold_date: {  }
    end

    assert_redirected_to hold_date_path(assigns(:hold_date))
  end

  test "should show hold_date" do
    get :show, id: @hold_date
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hold_date
    assert_response :success
  end

  test "should update hold_date" do
    put :update, id: @hold_date, hold_date: {  }
    assert_redirected_to hold_date_path(assigns(:hold_date))
  end

  test "should destroy hold_date" do
    assert_difference('HoldDate.count', -1) do
      delete :destroy, id: @hold_date
    end

    assert_redirected_to hold_dates_path
  end
end
