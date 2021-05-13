require 'test_helper'

class Provider::MedicoProvidersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider_medico_provider = provider_medico_providers(:one)
  end

  test "should get index" do
    get provider_medico_providers_url
    assert_response :success
  end

  test "should get new" do
    get new_provider_medico_provider_url
    assert_response :success
  end

  test "should create provider_medico_provider" do
    assert_difference('Provider::MedicoProvider.count') do
      post provider_medico_providers_url, params: { provider_medico_provider: { provider_medico_id: @provider_medico_provider.provider_medico_id, provider_provider_id: @provider_medico_provider.provider_provider_id } }
    end

    assert_redirected_to provider_medico_provider_url(Provider::MedicoProvider.last)
  end

  test "should show provider_medico_provider" do
    get provider_medico_provider_url(@provider_medico_provider)
    assert_response :success
  end

  test "should get edit" do
    get edit_provider_medico_provider_url(@provider_medico_provider)
    assert_response :success
  end

  test "should update provider_medico_provider" do
    patch provider_medico_provider_url(@provider_medico_provider), params: { provider_medico_provider: { provider_medico_id: @provider_medico_provider.provider_medico_id, provider_provider_id: @provider_medico_provider.provider_provider_id } }
    assert_redirected_to provider_medico_provider_url(@provider_medico_provider)
  end

  test "should destroy provider_medico_provider" do
    assert_difference('Provider::MedicoProvider.count', -1) do
      delete provider_medico_provider_url(@provider_medico_provider)
    end

    assert_redirected_to provider_medico_providers_url
  end
end
