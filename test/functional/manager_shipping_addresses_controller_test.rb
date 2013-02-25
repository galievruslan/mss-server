require 'test_helper'

class ManagerShippingAddressesControllerTest < ActionController::TestCase
  setup do
    @manager_shipping_address = manager_shipping_addresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manager_shipping_addresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manager_shipping_address" do
    assert_difference('ManagerShippingAddress.count') do
      post :create, manager_shipping_address: { manager_id: @manager_shipping_address.manager_id, shipping_address_id: @manager_shipping_address.shipping_address_id }
    end

    assert_redirected_to manager_shipping_address_path(assigns(:manager_shipping_address))
  end

  test "should show manager_shipping_address" do
    get :show, id: @manager_shipping_address
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manager_shipping_address
    assert_response :success
  end

  test "should update manager_shipping_address" do
    put :update, id: @manager_shipping_address, manager_shipping_address: { manager_id: @manager_shipping_address.manager_id, shipping_address_id: @manager_shipping_address.shipping_address_id }
    assert_redirected_to manager_shipping_address_path(assigns(:manager_shipping_address))
  end

  test "should destroy manager_shipping_address" do
    assert_difference('ManagerShippingAddress.count', -1) do
      delete :destroy, id: @manager_shipping_address
    end

    assert_redirected_to manager_shipping_addresses_path
  end
end
