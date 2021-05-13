require 'test_helper'

class Security::ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @security_profile = security_profiles(:one)
  end

  test "should get index" do
    get security_profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_security_profile_url
    assert_response :success
  end

  test "should create security_profile" do
    assert_difference('Security::Profile.count') do
      post security_profiles_url, params: { security_profile: { name: @security_profile.name, status: @security_profile.status, user_created_id: @security_profile.user_created_id, user_updated_id: @security_profile.user_updated_id } }
    end

    assert_redirected_to security_profile_url(Security::Profile.last)
  end

  test "should show security_profile" do
    get security_profile_url(@security_profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_security_profile_url(@security_profile)
    assert_response :success
  end

  test "should update security_profile" do
    patch security_profile_url(@security_profile), params: { security_profile: { name: @security_profile.name, status: @security_profile.status, user_created_id: @security_profile.user_created_id, user_updated_id: @security_profile.user_updated_id } }
    assert_redirected_to security_profile_url(@security_profile)
  end

  test "should destroy security_profile" do
    assert_difference('Security::Profile.count', -1) do
      delete security_profile_url(@security_profile)
    end

    assert_redirected_to security_profiles_url
  end
end
