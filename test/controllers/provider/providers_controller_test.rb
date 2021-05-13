require 'test_helper'

class Provider::ProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider_provider = provider_providers(:one)
  end

  test "should get index" do
    get provider_providers_url
    assert_response :success
  end

  test "should get new" do
    get new_provider_provider_url
    assert_response :success
  end

  test "should create provider_provider" do
    assert_difference('Provider::Provider.count') do
      post provider_providers_url, params: { provider_provider: { email: @provider_provider.email, name: @provider_provider.name, phone: @provider_provider.phone, provider_provider_type_id: @provider_provider.provider_provider_type_id, rif: @provider_provider.rif, territory_address_id: @provider_provider.territory_address_id } }
    end

    assert_redirected_to provider_provider_url(Provider::Provider.last)
  end

  test "should show provider_provider" do
    get provider_provider_url(@provider_provider)
    assert_response :success
  end

  test "should get edit" do
    get edit_provider_provider_url(@provider_provider)
    assert_response :success
  end

  test "should update provider_provider" do
    patch provider_provider_url(@provider_provider), params: { provider_provider: { email: @provider_provider.email, name: @provider_provider.name, phone: @provider_provider.phone, provider_provider_type_id: @provider_provider.provider_provider_type_id, rif: @provider_provider.rif, territory_address_id: @provider_provider.territory_address_id } }
    assert_redirected_to provider_provider_url(@provider_provider)
  end

  test "should destroy provider_provider" do
    assert_difference('Provider::Provider.count', -1) do
      delete provider_provider_url(@provider_provider)
    end

    assert_redirected_to provider_providers_url
  end
end
