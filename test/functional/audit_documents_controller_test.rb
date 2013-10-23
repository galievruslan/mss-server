require 'test_helper'

class AuditDocumentsControllerTest < ActionController::TestCase
  setup do
    @audit_document = audit_documents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:audit_documents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create audit_document" do
    assert_difference('AuditDocument.count') do
      post :create, audit_document: { comment: @audit_document.comment, date: @audit_document.date, manager_id: @audit_document.manager_id, percentage_shelves: @audit_document.percentage_shelves, shipping_address_id: @audit_document.shipping_address_id }
    end

    assert_redirected_to audit_document_path(assigns(:audit_document))
  end

  test "should show audit_document" do
    get :show, id: @audit_document
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @audit_document
    assert_response :success
  end

  test "should update audit_document" do
    put :update, id: @audit_document, audit_document: { comment: @audit_document.comment, date: @audit_document.date, manager_id: @audit_document.manager_id, percentage_shelves: @audit_document.percentage_shelves, shipping_address_id: @audit_document.shipping_address_id }
    assert_redirected_to audit_document_path(assigns(:audit_document))
  end

  test "should destroy audit_document" do
    assert_difference('AuditDocument.count', -1) do
      delete :destroy, id: @audit_document
    end

    assert_redirected_to audit_documents_path
  end
end
