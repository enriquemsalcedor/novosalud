require 'test_helper'

class Payment::ContractedProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get payment_contracted_products_index_url
    assert_response :success
  end

end
