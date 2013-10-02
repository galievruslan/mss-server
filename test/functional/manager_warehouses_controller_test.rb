require 'test_helper'

class ManagerWarehousesControllerTest < ActionController::TestCase
  setup do
    @manager_warehouse = manager_warehouses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manager_warehouses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manager_warehouse" do
    assert_difference('ManagerWarehouse.count') do
      post :create, manager_warehouse: { manager_id: @manager_warehouse.manager_id, warehouse_id: @manager_warehouse.warehouse_id }
    end

    assert_redirected_to manager_warehouse_path(assigns(:manager_warehouse))
  end

  test "should show manager_warehouse" do
    get :show, id: @manager_warehouse
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manager_warehouse
    assert_response :success
  end

  test "should update manager_warehouse" do
    put :update, id: @manager_warehouse, manager_warehouse: { manager_id: @manager_warehouse.manager_id, warehouse_id: @manager_warehouse.warehouse_id }
    assert_redirected_to manager_warehouse_path(assigns(:manager_warehouse))
  end

  test "should destroy manager_warehouse" do
    assert_difference('ManagerWarehouse.count', -1) do
      delete :destroy, id: @manager_warehouse
    end

    assert_redirected_to manager_warehouses_path
  end
end
