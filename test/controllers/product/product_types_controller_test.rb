require 'test_helper'

class Product::ProductTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_product_type = product_product_types(:one)
  end

  test "should get index" do
    get product_product_types_url
    assert_response :success
  end

  test "should get new" do
    get new_product_product_type_url
    assert_response :success
  end

  test "should create product_product_type" do
    assert_difference('Product::ProductType.count') do
      post product_product_types_url, params: { product_product_type: { description: @product_product_type.description, name: @product_product_type.name, status: @product_product_type.status, user_created_id: @product_product_type.user_created_id, user_updated_id: @product_product_type.user_updated_id } }
    end

    assert_redirected_to product_product_type_url(Product::ProductType.last)
  end

  test "should show product_product_type" do
    get product_product_type_url(@product_product_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_product_type_url(@product_product_type)
    assert_response :success
  end

  test "should update product_product_type" do
    patch product_product_type_url(@product_product_type), params: { product_product_type: { description: @product_product_type.description, name: @product_product_type.name, status: @product_product_type.status, user_created_id: @product_product_type.user_created_id, user_updated_id: @product_product_type.user_updated_id } }
    assert_redirected_to product_product_type_url(@product_product_type)
  end

  test "should destroy product_product_type" do
    assert_difference('Product::ProductType.count', -1) do
      delete product_product_type_url(@product_product_type)
    end

    assert_redirected_to product_product_types_url
  end
end
