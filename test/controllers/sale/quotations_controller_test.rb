require 'test_helper'

class Sale::QuotationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sale_quotation = sale_quotations(:one)
  end

  test "should get index" do
    get sale_quotations_url
    assert_response :success
  end

  test "should get new" do
    get new_sale_quotation_url
    assert_response :success
  end

  test "should create sale_quotation" do
    assert_difference('Sale::Quotation.count') do
      post sale_quotations_url, params: { sale_quotation: { quoting_number: @sale_quotation.quoting_number, status: @sale_quotation.status, user_created_id: @sale_quotation.user_created_id, user_id: @sale_quotation.user_id, user_updated_id: @sale_quotation.user_updated_id, valid_since: @sale_quotation.valid_since, valid_until: @sale_quotation.valid_until } }
    end

    assert_redirected_to sale_quotation_url(Sale::Quotation.last)
  end

  test "should show sale_quotation" do
    get sale_quotation_url(@sale_quotation)
    assert_response :success
  end

  test "should get edit" do
    get edit_sale_quotation_url(@sale_quotation)
    assert_response :success
  end

  test "should update sale_quotation" do
    patch sale_quotation_url(@sale_quotation), params: { sale_quotation: { quoting_number: @sale_quotation.quoting_number, status: @sale_quotation.status, user_created_id: @sale_quotation.user_created_id, user_id: @sale_quotation.user_id, user_updated_id: @sale_quotation.user_updated_id, valid_since: @sale_quotation.valid_since, valid_until: @sale_quotation.valid_until } }
    assert_redirected_to sale_quotation_url(@sale_quotation)
  end

  test "should destroy sale_quotation" do
    assert_difference('Sale::Quotation.count', -1) do
      delete sale_quotation_url(@sale_quotation)
    end

    assert_redirected_to sale_quotations_url
  end
end
