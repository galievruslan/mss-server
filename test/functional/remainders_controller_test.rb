require 'test_helper'

class RemaindersControllerTest < ActionController::TestCase
  setup do
    @remainder = remainders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:remainders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create remainder" do
    assert_difference('Remainder.count') do
      post :create, remainder: { count: @remainder.count, product_id: @remainder.product_id, unit_of_measure_id: @remainder.unit_of_measure_id, warehouse_id: @remainder.warehouse_id }
    end

    assert_redirected_to remainder_path(assigns(:remainder))
  end

  test "should show remainder" do
    get :show, id: @remainder
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @remainder
    assert_response :success
  end

  test "should update remainder" do
    put :update, id: @remainder, remainder: { count: @remainder.count, product_id: @remainder.product_id, unit_of_measure_id: @remainder.unit_of_measure_id, warehouse_id: @remainder.warehouse_id }
    assert_redirected_to remainder_path(assigns(:remainder))
  end

  test "should destroy remainder" do
    assert_difference('Remainder.count', -1) do
      delete :destroy, id: @remainder
    end

    assert_redirected_to remainders_path
  end
end
