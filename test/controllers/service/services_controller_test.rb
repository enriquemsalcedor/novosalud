require 'test_helper'

class Service::ServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service_service = service_services(:one)
  end

  test "should get index" do
    get service_services_url
    assert_response :success
  end

  test "should get new" do
    get new_service_service_url
    assert_response :success
  end

  test "should create service_service" do
    assert_difference('Service::Service.count') do
      post service_services_url, params: { service_service: { appointment_date: @service_service.appointment_date, beneficiary_id: @service_service.beneficiary_id, code: @service_service.code, date_service: @service_service.date_service, motive_id: @service_service.motive_id, payment_contracted_product_id: @service_service.payment_contracted_product_id, provider_medico_provider_id: @service_service.provider_medico_provider_id, status: @service_service.status, user_created_id: @service_service.user_created_id, user_updated_id: @service_service.user_updated_id } }
    end

    assert_redirected_to service_service_url(Service::Service.last)
  end

  test "should show service_service" do
    get service_service_url(@service_service)
    assert_response :success
  end

  test "should get edit" do
    get edit_service_service_url(@service_service)
    assert_response :success
  end

  test "should update service_service" do
    patch service_service_url(@service_service), params: { service_service: { appointment_date: @service_service.appointment_date, beneficiary_id: @service_service.beneficiary_id, code: @service_service.code, date_service: @service_service.date_service, motive_id: @service_service.motive_id, payment_contracted_product_id: @service_service.payment_contracted_product_id, provider_medico_provider_id: @service_service.provider_medico_provider_id, status: @service_service.status, user_created_id: @service_service.user_created_id, user_updated_id: @service_service.user_updated_id } }
    assert_redirected_to service_service_url(@service_service)
  end

  test "should destroy service_service" do
    assert_difference('Service::Service.count', -1) do
      delete service_service_url(@service_service)
    end

    assert_redirected_to service_services_url
  end
end
