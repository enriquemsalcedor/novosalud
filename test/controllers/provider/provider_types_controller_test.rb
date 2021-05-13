require 'test_helper'

class Provider::ProviderTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider_provider_type = provider_provider_types(:one)
  end

  test "should get index" do
    get provider_provider_types_url
    assert_response :success
  end

  test "should get new" do
    get new_provider_provider_type_url
    assert_response :success
  end

  test "should create provider_provider_type" do
    assert_difference('Provider::ProviderType.count') do
      post provider_provider_types_url, params: { provider_provider_type: { name: @provider_provider_type.name } }
    end

    assert_redirected_to provider_provider_type_url(Provider::ProviderType.last)
  end

  test "should show provider_provider_type" do
    get provider_provider_type_url(@provider_provider_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_provider_provider_type_url(@provider_provider_type)
    assert_response :success
  end

  test "should update provider_provider_type" do
    patch provider_provider_type_url(@provider_provider_type), params: { provider_provider_type: { name: @provider_provider_type.name } }
    assert_redirected_to provider_provider_type_url(@provider_provider_type)
  end

  test "should destroy provider_provider_type" do
    assert_difference('Provider::ProviderType.count', -1) do
      delete provider_provider_type_url(@provider_provider_type)
    end

    assert_redirected_to provider_provider_types_url
  end
end
