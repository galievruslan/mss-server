require 'test_helper'

class AuditDocumentItemsControllerTest < ActionController::TestCase
  setup do
    @audit_document_item = audit_document_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:audit_document_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create audit_document_item" do
    assert_difference('AuditDocumentItem.count') do
      post :create, audit_document_item: { audit_document_id: @audit_document_item.audit_document_id, count: @audit_document_item.count, face: @audit_document_item.face, facing: @audit_document_item.facing, golden_shelf: @audit_document_item.golden_shelf, price: @audit_document_item.price, product_id: @audit_document_item.product_id }
    end

    assert_redirected_to audit_document_item_path(assigns(:audit_document_item))
  end

  test "should show audit_document_item" do
    get :show, id: @audit_document_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @audit_document_item
    assert_response :success
  end

  test "should update audit_document_item" do
    put :update, id: @audit_document_item, audit_document_item: { audit_document_id: @audit_document_item.audit_document_id, count: @audit_document_item.count, face: @audit_document_item.face, facing: @audit_document_item.facing, golden_shelf: @audit_document_item.golden_shelf, price: @audit_document_item.price, product_id: @audit_document_item.product_id }
    assert_redirected_to audit_document_item_path(assigns(:audit_document_item))
  end

  test "should destroy audit_document_item" do
    assert_difference('AuditDocumentItem.count', -1) do
      delete :destroy, id: @audit_document_item
    end

    assert_redirected_to audit_document_items_path
  end
end
