require 'test_helper'

class Provider::MedicosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider_medico = provider_medicos(:one)
  end

  test "should get index" do
    get provider_medicos_url
    assert_response :success
  end

  test "should get new" do
    get new_provider_medico_url
    assert_response :success
  end

  test "should create provider_medico" do
    assert_difference('Provider::Medico.count') do
      post provider_medicos_url, params: { provider_medico: { code_medico: @provider_medico.code_medico, people_id: @provider_medico.people_id } }
    end

    assert_redirected_to provider_medico_url(Provider::Medico.last)
  end

  test "should show provider_medico" do
    get provider_medico_url(@provider_medico)
    assert_response :success
  end

  test "should get edit" do
    get edit_provider_medico_url(@provider_medico)
    assert_response :success
  end

  test "should update provider_medico" do
    patch provider_medico_url(@provider_medico), params: { provider_medico: { code_medico: @provider_medico.code_medico, people_id: @provider_medico.people_id } }
    assert_redirected_to provider_medico_url(@provider_medico)
  end

  test "should destroy provider_medico" do
    assert_difference('Provider::Medico.count', -1) do
      delete provider_medico_url(@provider_medico)
    end

    assert_redirected_to provider_medicos_url
  end
end
