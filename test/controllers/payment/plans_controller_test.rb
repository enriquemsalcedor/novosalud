require 'test_helper'

class Payment::PlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payment_plan = payment_plans(:one)
  end

  test "should get index" do
    get payment_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_payment_plan_url
    assert_response :success
  end

  test "should create payment_plan" do
    assert_difference('Payment::Plan.count') do
      post payment_plans_url, params: { payment_plan: { customer_id: @payment_plan.customer_id, status: @payment_plan.status, user_created_id: @payment_plan.user_created_id, user_updated_id: @payment_plan.user_updated_id, valid_since: @payment_plan.valid_since, valid_until: @payment_plan.valid_until } }
    end

    assert_redirected_to payment_plan_url(Payment::Plan.last)
  end

  test "should show payment_plan" do
    get payment_plan_url(@payment_plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_payment_plan_url(@payment_plan)
    assert_response :success
  end

  test "should update payment_plan" do
    patch payment_plan_url(@payment_plan), params: { payment_plan: { customer_id: @payment_plan.customer_id, status: @payment_plan.status, user_created_id: @payment_plan.user_created_id, user_updated_id: @payment_plan.user_updated_id, valid_since: @payment_plan.valid_since, valid_until: @payment_plan.valid_until } }
    assert_redirected_to payment_plan_url(@payment_plan)
  end

  test "should destroy payment_plan" do
    assert_difference('Payment::Plan.count', -1) do
      delete payment_plan_url(@payment_plan)
    end

    assert_redirected_to payment_plans_url
  end
end
