require 'test_helper'

class CustomerCreditsControllerTest < ActionController::TestCase
  setup do
    @customer_credit = customer_credits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:customer_credits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create customer_credit" do
    assert_difference('CustomerCredit.count') do
      post :create, customer_credit: { credits_available: @customer_credit.credits_available, customer_id: @customer_credit.customer_id, item_id: @customer_credit.item_id }
    end

    assert_redirected_to customer_credit_path(assigns(:customer_credit))
  end

  test "should show customer_credit" do
    get :show, id: @customer_credit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @customer_credit
    assert_response :success
  end

  test "should update customer_credit" do
    put :update, id: @customer_credit, customer_credit: { credits_available: @customer_credit.credits_available, customer_id: @customer_credit.customer_id, item_id: @customer_credit.item_id }
    assert_redirected_to customer_credit_path(assigns(:customer_credit))
  end

  test "should destroy customer_credit" do
    assert_difference('CustomerCredit.count', -1) do
      delete :destroy, id: @customer_credit
    end

    assert_redirected_to customer_credits_path
  end
end
