require 'test_helper'

class Sale::ProductQuotationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sale_product_quotation = sale_product_quotations(:one)
  end

  test "should get index" do
    get sale_product_quotations_url
    assert_response :success
  end

  test "should get new" do
    get new_sale_product_quotation_url
    assert_response :success
  end

  test "should create sale_product_quotation" do
    assert_difference('Sale::ProductQuotation.count') do
      post sale_product_quotations_url, params: { sale_product_quotation: { product_product_id: @sale_product_quotation.product_product_id, quantity: @sale_product_quotation.quantity, sale_quotation_id: @sale_product_quotation.sale_quotation_id } }
    end

    assert_redirected_to sale_product_quotation_url(Sale::ProductQuotation.last)
  end

  test "should show sale_product_quotation" do
    get sale_product_quotation_url(@sale_product_quotation)
    assert_response :success
  end

  test "should get edit" do
    get edit_sale_product_quotation_url(@sale_product_quotation)
    assert_response :success
  end

  test "should update sale_product_quotation" do
    patch sale_product_quotation_url(@sale_product_quotation), params: { sale_product_quotation: { product_product_id: @sale_product_quotation.product_product_id, quantity: @sale_product_quotation.quantity, sale_quotation_id: @sale_product_quotation.sale_quotation_id } }
    assert_redirected_to sale_product_quotation_url(@sale_product_quotation)
  end

  test "should destroy sale_product_quotation" do
    assert_difference('Sale::ProductQuotation.count', -1) do
      delete sale_product_quotation_url(@sale_product_quotation)
    end

    assert_redirected_to sale_product_quotations_url
  end
end
