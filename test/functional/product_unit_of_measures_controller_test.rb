require 'test_helper'

class ProductUnitOfMeasuresControllerTest < ActionController::TestCase
  setup do
    @product_unit_of_measure = product_unit_of_measures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:product_unit_of_measures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create product_unit_of_measure" do
    assert_difference('ProductUnitOfMeasure.count') do
      post :create, product_unit_of_measure: { count_in_base_unit: @product_unit_of_measure.count_in_base_unit, product_id: @product_unit_of_measure.product_id, unit_of_measure_id: @product_unit_of_measure.unit_of_measure_id }
    end

    assert_redirected_to product_unit_of_measure_path(assigns(:product_unit_of_measure))
  end

  test "should show product_unit_of_measure" do
    get :show, id: @product_unit_of_measure
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @product_unit_of_measure
    assert_response :success
  end

  test "should update product_unit_of_measure" do
    put :update, id: @product_unit_of_measure, product_unit_of_measure: { count_in_base_unit: @product_unit_of_measure.count_in_base_unit, product_id: @product_unit_of_measure.product_id, unit_of_measure_id: @product_unit_of_measure.unit_of_measure_id }
    assert_redirected_to product_unit_of_measure_path(assigns(:product_unit_of_measure))
  end

  test "should destroy product_unit_of_measure" do
    assert_difference('ProductUnitOfMeasure.count', -1) do
      delete :destroy, id: @product_unit_of_measure
    end

    assert_redirected_to product_unit_of_measures_path
  end
end
