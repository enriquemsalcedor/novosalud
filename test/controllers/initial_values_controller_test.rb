require 'test_helper'

class InitialValuesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @initial_value = initial_values(:one)
  end

  test "should get index" do
    get initial_values_url
    assert_response :success
  end

  test "should get new" do
    get new_initial_value_url
    assert_response :success
  end

  test "should create initial_value" do
    assert_difference('InitialValue.count') do
      post initial_values_url, params: { initial_value: { days_validity: @initial_value.days_validity, max_quantity_product: @initial_value.max_quantity_product, max_refech_service: @initial_value.max_refech_service, number_employee: @initial_value.number_employee } }
    end

    assert_redirected_to initial_value_url(InitialValue.last)
  end

  test "should show initial_value" do
    get initial_value_url(@initial_value)
    assert_response :success
  end

  test "should get edit" do
    get edit_initial_value_url(@initial_value)
    assert_response :success
  end

  test "should update initial_value" do
    patch initial_value_url(@initial_value), params: { initial_value: { days_validity: @initial_value.days_validity, max_quantity_product: @initial_value.max_quantity_product, max_refech_service: @initial_value.max_refech_service, number_employee: @initial_value.number_employee } }
    assert_redirected_to initial_value_url(@initial_value)
  end

  test "should destroy initial_value" do
    assert_difference('InitialValue.count', -1) do
      delete initial_value_url(@initial_value)
    end

    assert_redirected_to initial_values_url
  end
end
