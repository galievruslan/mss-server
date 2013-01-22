require 'test_helper'

class UnitOfMeasuresControllerTest < ActionController::TestCase
  setup do
    @unit_of_measure = unit_of_measures(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:unit_of_measures)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create unit_of_measure" do
    assert_difference('UnitOfMeasure.count') do
      post :create, unit_of_measure: { name: @unit_of_measure.name }
    end

    assert_redirected_to unit_of_measure_path(assigns(:unit_of_measure))
  end

  test "should show unit_of_measure" do
    get :show, id: @unit_of_measure
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @unit_of_measure
    assert_response :success
  end

  test "should update unit_of_measure" do
    put :update, id: @unit_of_measure, unit_of_measure: { name: @unit_of_measure.name }
    assert_redirected_to unit_of_measure_path(assigns(:unit_of_measure))
  end

  test "should destroy unit_of_measure" do
    assert_difference('UnitOfMeasure.count', -1) do
      delete :destroy, id: @unit_of_measure
    end

    assert_redirected_to unit_of_measures_path
  end
end
