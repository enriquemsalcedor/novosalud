require 'test_helper'

class Security::RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @security_role = security_roles(:one)
  end

  test "should get index" do
    get security_roles_url
    assert_response :success
  end

  test "should get new" do
    get new_security_role_url
    assert_response :success
  end

  test "should create security_role" do
    assert_difference('Security::Role.count') do
      post security_roles_url, params: { security_role: { name: @security_role.name, status: @security_role.status, user_created_id: @security_role.user_created_id, user_updated_id: @security_role.user_updated_id } }
    end

    assert_redirected_to security_role_url(Security::Role.last)
  end

  test "should show security_role" do
    get security_role_url(@security_role)
    assert_response :success
  end

  test "should get edit" do
    get edit_security_role_url(@security_role)
    assert_response :success
  end

  test "should update security_role" do
    patch security_role_url(@security_role), params: { security_role: { name: @security_role.name, status: @security_role.status, user_created_id: @security_role.user_created_id, user_updated_id: @security_role.user_updated_id } }
    assert_redirected_to security_role_url(@security_role)
  end

  test "should destroy security_role" do
    assert_difference('Security::Role.count', -1) do
      delete security_role_url(@security_role)
    end

    assert_redirected_to security_roles_url
  end
end
