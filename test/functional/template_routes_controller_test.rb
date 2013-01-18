require 'test_helper'

class TemplateRoutesControllerTest < ActionController::TestCase
  setup do
    @template_route = template_routes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:template_routes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create template_route" do
    assert_difference('TemplateRoute.count') do
      post :create, template_route: { day_of_week: @template_route.day_of_week, manager_id: @template_route.manager_id }
    end

    assert_redirected_to template_route_path(assigns(:template_route))
  end

  test "should show template_route" do
    get :show, id: @template_route
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @template_route
    assert_response :success
  end

  test "should update template_route" do
    put :update, id: @template_route, template_route: { day_of_week: @template_route.day_of_week, manager_id: @template_route.manager_id }
    assert_redirected_to template_route_path(assigns(:template_route))
  end

  test "should destroy template_route" do
    assert_difference('TemplateRoute.count', -1) do
      delete :destroy, id: @template_route
    end

    assert_redirected_to template_routes_path
  end
end
