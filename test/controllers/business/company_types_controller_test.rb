require 'test_helper'

class Business::CompanyTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @business_company_type = business_company_types(:one)
  end

  test "should get index" do
    get business_company_types_url
    assert_response :success
  end

  test "should get new" do
    get new_business_company_type_url
    assert_response :success
  end

  test "should create business_company_type" do
    assert_difference('Business::CompanyType.count') do
      post business_company_types_url, params: { business_company_type: { limit: @business_company_type.limit, name: @business_company_type.name } }
    end

    assert_redirected_to business_company_type_url(Business::CompanyType.last)
  end

  test "should show business_company_type" do
    get business_company_type_url(@business_company_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_business_company_type_url(@business_company_type)
    assert_response :success
  end

  test "should update business_company_type" do
    patch business_company_type_url(@business_company_type), params: { business_company_type: { limit: @business_company_type.limit, name: @business_company_type.name } }
    assert_redirected_to business_company_type_url(@business_company_type)
  end

  test "should destroy business_company_type" do
    assert_difference('Business::CompanyType.count', -1) do
      delete business_company_type_url(@business_company_type)
    end

    assert_redirected_to business_company_types_url
  end
end
