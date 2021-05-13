require 'test_helper'

class Security::RoleProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @security_role_profile = security_role_profiles(:one)
  end

  test "should get index" do
    get security_role_profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_security_role_profile_url
    assert_response :success
  end

  test "should create security_role_profile" do
    assert_difference('Security::RoleProfile.count') do
      post security_role_profiles_url, params: { security_role_profile: { end_date: @security_role_profile.end_date, security_profile_id: @security_role_profile.security_profile_id, security_role_id: @security_role_profile.security_role_id, start_date: @security_role_profile.start_date } }
    end

    assert_redirected_to security_role_profile_url(Security::RoleProfile.last)
  end

  test "should show security_role_profile" do
    get security_role_profile_url(@security_role_profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_security_role_profile_url(@security_role_profile)
    assert_response :success
  end

  test "should update security_role_profile" do
    patch security_role_profile_url(@security_role_profile), params: { security_role_profile: { end_date: @security_role_profile.end_date, security_profile_id: @security_role_profile.security_profile_id, security_role_id: @security_role_profile.security_role_id, start_date: @security_role_profile.start_date } }
    assert_redirected_to security_role_profile_url(@security_role_profile)
  end

  test "should destroy security_role_profile" do
    assert_difference('Security::RoleProfile.count', -1) do
      delete security_role_profile_url(@security_role_profile)
    end

    assert_redirected_to security_role_profiles_url
  end
end
