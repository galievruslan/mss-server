require 'test_helper'

class TemplateRoutePointsControllerTest < ActionController::TestCase
  setup do
    @template_route_point = template_route_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:template_route_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create template_route_point" do
    assert_difference('TemplateRoutePoint.count') do
      post :create, template_route_point: { shipping_address_id: @template_route_point.shipping_address_id, template_route_id: @template_route_point.template_route_id }
    end

    assert_redirected_to template_route_point_path(assigns(:template_route_point))
  end

  test "should show template_route_point" do
    get :show, id: @template_route_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @template_route_point
    assert_response :success
  end

  test "should update template_route_point" do
    put :update, id: @template_route_point, template_route_point: { shipping_address_id: @template_route_point.shipping_address_id, template_route_id: @template_route_point.template_route_id }
    assert_redirected_to template_route_point_path(assigns(:template_route_point))
  end

  test "should destroy template_route_point" do
    assert_difference('TemplateRoutePoint.count', -1) do
      delete :destroy, id: @template_route_point
    end

    assert_redirected_to template_route_points_path
  end
end
