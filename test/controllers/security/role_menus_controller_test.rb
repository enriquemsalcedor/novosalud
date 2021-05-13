require 'test_helper'

class Security::RoleMenusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @security_role_menu = security_role_menus(:one)
  end

  test "should get index" do
    get security_role_menus_url
    assert_response :success
  end

  test "should get new" do
    get new_security_role_menu_url
    assert_response :success
  end

  test "should create security_role_menu" do
    assert_difference('Security::RoleMenu.count') do
      post security_role_menus_url, params: { security_role_menu: { security_menu_id: @security_role_menu.security_menu_id, security_role_id: @security_role_menu.security_role_id } }
    end

    assert_redirected_to security_role_menu_url(Security::RoleMenu.last)
  end

  test "should show security_role_menu" do
    get security_role_menu_url(@security_role_menu)
    assert_response :success
  end

  test "should get edit" do
    get edit_security_role_menu_url(@security_role_menu)
    assert_response :success
  end

  test "should update security_role_menu" do
    patch security_role_menu_url(@security_role_menu), params: { security_role_menu: { security_menu_id: @security_role_menu.security_menu_id, security_role_id: @security_role_menu.security_role_id } }
    assert_redirected_to security_role_menu_url(@security_role_menu)
  end

  test "should destroy security_role_menu" do
    assert_difference('Security::RoleMenu.count', -1) do
      delete security_role_menu_url(@security_role_menu)
    end

    assert_redirected_to security_role_menus_url
  end
end
