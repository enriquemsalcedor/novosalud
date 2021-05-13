require 'test_helper'

class Sale::PackageQuotationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sale_package_quotation = sale_package_quotations(:one)
  end

  test "should get index" do
    get sale_package_quotations_url
    assert_response :success
  end

  test "should get new" do
    get new_sale_package_quotation_url
    assert_response :success
  end

  test "should create sale_package_quotation" do
    assert_difference('Sale::PackageQuotation.count') do
      post sale_package_quotations_url, params: { sale_package_quotation: { colection_package_id: @sale_package_quotation.colection_package_id, quantity: @sale_package_quotation.quantity, sale_quotation_id: @sale_package_quotation.sale_quotation_id } }
    end

    assert_redirected_to sale_package_quotation_url(Sale::PackageQuotation.last)
  end

  test "should show sale_package_quotation" do
    get sale_package_quotation_url(@sale_package_quotation)
    assert_response :success
  end

  test "should get edit" do
    get edit_sale_package_quotation_url(@sale_package_quotation)
    assert_response :success
  end

  test "should update sale_package_quotation" do
    patch sale_package_quotation_url(@sale_package_quotation), params: { sale_package_quotation: { colection_package_id: @sale_package_quotation.colection_package_id, quantity: @sale_package_quotation.quantity, sale_quotation_id: @sale_package_quotation.sale_quotation_id } }
    assert_redirected_to sale_package_quotation_url(@sale_package_quotation)
  end

  test "should destroy sale_package_quotation" do
    assert_difference('Sale::PackageQuotation.count', -1) do
      delete sale_package_quotation_url(@sale_package_quotation)
    end

    assert_redirected_to sale_package_quotations_url
  end
end
