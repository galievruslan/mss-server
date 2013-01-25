require 'test_helper'

class PriceListLinesControllerTest < ActionController::TestCase
  setup do
    @price_list_line = price_list_lines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:price_list_lines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create price_list_line" do
    assert_difference('PriceListLine.count') do
      post :create, price_list_line: { price: @price_list_line.price, price_list_id: @price_list_line.price_list_id, product_id: @price_list_line.product_id }
    end

    assert_redirected_to price_list_line_path(assigns(:price_list_line))
  end

  test "should show price_list_line" do
    get :show, id: @price_list_line
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @price_list_line
    assert_response :success
  end

  test "should update price_list_line" do
    put :update, id: @price_list_line, price_list_line: { price: @price_list_line.price, price_list_id: @price_list_line.price_list_id, product_id: @price_list_line.product_id }
    assert_redirected_to price_list_line_path(assigns(:price_list_line))
  end

  test "should destroy price_list_line" do
    assert_difference('PriceListLine.count', -1) do
      delete :destroy, id: @price_list_line
    end

    assert_redirected_to price_list_lines_path
  end
end
