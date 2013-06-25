require 'test_helper'

class ShareDatesControllerTest < ActionController::TestCase
  setup do
    @share_date = share_dates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:share_dates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create share_date" do
    assert_difference('ShareDate.count') do
      post :create, share_date: { customer_id: @share_date.customer_id, date: @share_date.date }
    end

    assert_redirected_to share_date_path(assigns(:share_date))
  end

  test "should show share_date" do
    get :show, id: @share_date
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @share_date
    assert_response :success
  end

  test "should update share_date" do
    put :update, id: @share_date, share_date: { customer_id: @share_date.customer_id, date: @share_date.date }
    assert_redirected_to share_date_path(assigns(:share_date))
  end

  test "should destroy share_date" do
    assert_difference('ShareDate.count', -1) do
      delete :destroy, id: @share_date
    end

    assert_redirected_to share_dates_path
  end
end
