require 'test_helper'

class Business::CompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business_company = business_companies(:one)
  end

  test "should get index" do
    get business_companies_url
    assert_response :success
  end

  test "should get new" do
    get new_business_company_url
    assert_response :success
  end

  test "should create business_company" do
    assert_difference('Business::Company.count') do
      post business_companies_url, params: { business_company: { business_company_type_id: @business_company.business_company_type_id, email: @business_company.email, name: @business_company.name, rif: @business_company.rif, status: @business_company.status, territory_city_id: @business_company.territory_city_id, territory_country_id: @business_company.territory_country_id, territory_state_id: @business_company.territory_state_id, type_identification: @business_company.type_identification } }
    end

    assert_redirected_to business_company_url(Business::Company.last)
  end

  test "should show business_company" do
    get business_company_url(@business_company)
    assert_response :success
  end

  test "should get edit" do
    get edit_business_company_url(@business_company)
    assert_response :success
  end

  test "should update business_company" do
    patch business_company_url(@business_company), params: { business_company: { business_company_type_id: @business_company.business_company_type_id, email: @business_company.email, name: @business_company.name, rif: @business_company.rif, status: @business_company.status, territory_city_id: @business_company.territory_city_id, territory_country_id: @business_company.territory_country_id, territory_state_id: @business_company.territory_state_id, type_identification: @business_company.type_identification } }
    assert_redirected_to business_company_url(@business_company)
  end

  test "should destroy business_company" do
    assert_difference('Business::Company.count', -1) do
      delete business_company_url(@business_company)
    end

    assert_redirected_to business_companies_url
  end
end
