require 'test_helper'

class Security::RoleTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @security_role_type = security_role_types(:one)
  end

  test "should get index" do
    get security_role_types_url
    assert_response :success
  end

  test "should get new" do
    get new_security_role_type_url
    assert_response :success
  end

  test "should create security_role_type" do
    assert_difference('Security::RoleType.count') do
      post security_role_types_url, params: { security_role_type: { name: @security_role_type.name, status: @security_role_type.status, user_created_id: @security_role_type.user_created_id, user_updated_id: @security_role_type.user_updated_id } }
    end

    assert_redirected_to security_role_type_url(Security::RoleType.last)
  end

  test "should show security_role_type" do
    get security_role_type_url(@security_role_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_security_role_type_url(@security_role_type)
    assert_response :success
  end

  test "should update security_role_type" do
    patch security_role_type_url(@security_role_type), params: { security_role_type: { name: @security_role_type.name, status: @security_role_type.status, user_created_id: @security_role_type.user_created_id, user_updated_id: @security_role_type.user_updated_id } }
    assert_redirected_to security_role_type_url(@security_role_type)
  end

  test "should destroy security_role_type" do
    assert_difference('Security::RoleType.count', -1) do
      delete security_role_type_url(@security_role_type)
    end

    assert_redirected_to security_role_types_url
  end
end
