require 'test_helper'

class MobileClientsControllerTest < ActionController::TestCase
  setup do
    @mobile_client = mobile_clients(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mobile_clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mobile_client" do
    assert_difference('MobileClient.count') do
      post :create, mobile_client: { date: @mobile_client.date, file: @mobile_client.file, type: @mobile_client.type, version: @mobile_client.version }
    end

    assert_redirected_to mobile_client_path(assigns(:mobile_client))
  end

  test "should show mobile_client" do
    get :show, id: @mobile_client
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @mobile_client
    assert_response :success
  end

  test "should update mobile_client" do
    put :update, id: @mobile_client, mobile_client: { date: @mobile_client.date, file: @mobile_client.file, type: @mobile_client.type, version: @mobile_client.version }
    assert_redirected_to mobile_client_path(assigns(:mobile_client))
  end

  test "should destroy mobile_client" do
    assert_difference('MobileClient.count', -1) do
      delete :destroy, id: @mobile_client
    end

    assert_redirected_to mobile_clients_path
  end
end
