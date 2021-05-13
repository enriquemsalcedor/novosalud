require 'test_helper'

class MethodPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @method_payment = method_payments(:one)
  end

  test "should get index" do
    get method_payments_url
    assert_response :success
  end

  test "should get new" do
    get new_method_payment_url
    assert_response :success
  end

  test "should create method_payment" do
    assert_difference('MethodPayment.count') do
      post method_payments_url, params: { method_payment: { name: @method_payment.name, status: @method_payment.status, user_created_id: @method_payment.user_created_id, user_updated_id: @method_payment.user_updated_id } }
    end

    assert_redirected_to method_payment_url(MethodPayment.last)
  end

  test "should show method_payment" do
    get method_payment_url(@method_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_method_payment_url(@method_payment)
    assert_response :success
  end

  test "should update method_payment" do
    patch method_payment_url(@method_payment), params: { method_payment: { name: @method_payment.name, status: @method_payment.status, user_created_id: @method_payment.user_created_id, user_updated_id: @method_payment.user_updated_id } }
    assert_redirected_to method_payment_url(@method_payment)
  end

  test "should destroy method_payment" do
    assert_difference('MethodPayment.count', -1) do
      delete method_payment_url(@method_payment)
    end

    assert_redirected_to method_payments_url
  end
end
