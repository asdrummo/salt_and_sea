require 'test_helper'

class AddSharesControllerTest < ActionController::TestCase
  setup do
    @add_share = add_shares(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:add_shares)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create add_share" do
    assert_difference('AddShare.count') do
      post :create, add_share: { customer_id: @add_share.customer_id, customer_id: @add_share.customer_id, date: @add_share.date, product_id: @add_share.product_id, quantity: @add_share.quantity }
    end

    assert_redirected_to add_share_path(assigns(:add_share))
  end

  test "should show add_share" do
    get :show, id: @add_share
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @add_share
    assert_response :success
  end

  test "should update add_share" do
    put :update, id: @add_share, add_share: { customer_id: @add_share.customer_id, customer_id: @add_share.customer_id, date: @add_share.date, product_id: @add_share.product_id, quantity: @add_share.quantity }
    assert_redirected_to add_share_path(assigns(:add_share))
  end

  test "should destroy add_share" do
    assert_difference('AddShare.count', -1) do
      delete :destroy, id: @add_share
    end

    assert_redirected_to add_shares_path
  end
end
