require 'test_helper'

class PrivilegesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @privilege = privileges(:one)
  end

  test "should get index" do
    get privileges_url
    assert_response :success
  end

  test "should get new" do
    get new_privilege_url
    assert_response :success
  end

  test "should create privilege" do
    assert_difference('Privilege.count') do
      post privileges_url, params: { privilege: { name: @privilege.name } }
    end

    assert_redirected_to privilege_url(Privilege.last)
  end

  test "should show privilege" do
    get privilege_url(@privilege)
    assert_response :success
  end

  test "should get edit" do
    get edit_privilege_url(@privilege)
    assert_response :success
  end

  test "should update privilege" do
    patch privilege_url(@privilege), params: { privilege: { name: @privilege.name } }
    assert_redirected_to privilege_url(@privilege)
  end

  test "should destroy privilege" do
    assert_difference('Privilege.count', -1) do
      delete privilege_url(@privilege)
    end

    assert_redirected_to privileges_url
  end
end
