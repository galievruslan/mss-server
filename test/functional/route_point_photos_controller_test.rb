require 'test_helper'

class RoutePointPhotosControllerTest < ActionController::TestCase
  setup do
    @route_point_photo = route_point_photos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:route_point_photos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create route_point_photo" do
    assert_difference('RoutePointPhoto.count') do
      post :create, route_point_photo: { comment: @route_point_photo.comment, photo: @route_point_photo.photo, route_point_id: @route_point_photo.route_point_id }
    end

    assert_redirected_to route_point_photo_path(assigns(:route_point_photo))
  end

  test "should show route_point_photo" do
    get :show, id: @route_point_photo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @route_point_photo
    assert_response :success
  end

  test "should update route_point_photo" do
    put :update, id: @route_point_photo, route_point_photo: { comment: @route_point_photo.comment, photo: @route_point_photo.photo, route_point_id: @route_point_photo.route_point_id }
    assert_redirected_to route_point_photo_path(assigns(:route_point_photo))
  end

  test "should destroy route_point_photo" do
    assert_difference('RoutePointPhoto.count', -1) do
      delete :destroy, id: @route_point_photo
    end

    assert_redirected_to route_point_photos_path
  end
end
