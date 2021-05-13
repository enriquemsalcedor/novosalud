require 'test_helper'

class Payment::CheckoutControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get payment_checkout_index_url
    assert_response :success
  end

  test "should get show" do
    get payment_checkout_show_url
    assert_response :success
  end

end
