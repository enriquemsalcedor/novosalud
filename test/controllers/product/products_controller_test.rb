require 'test_helper'

class Product::ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product_product = product_products(:one)
  end

  test "should get index" do
    get product_products_url
    assert_response :success
  end

  test "should get new" do
    get new_product_product_url
    assert_response :success
  end

  test "should create product_product" do
    assert_difference('Product::Product.count') do
      post product_products_url, params: { product_product: { category: @product_product.category, code: @product_product.code, expiration_date: @product_product.expiration_date, name: @product_product.name, price: @product_product.price, product_product_type_id: @product_product.product_product_type_id, provider_provider_id: @product_product.provider_provider_id, publication_date: @product_product.publication_date, speciality_id: @product_product.speciality_id, status: @product_product.status, terms: @product_product.terms, user_created_id: @product_product.user_created_id, user_updated_id: @product_product.user_updated_id, valid_since: @product_product.valid_since, valid_until: @product_product.valid_until } }
    end

    assert_redirected_to product_product_url(Product::Product.last)
  end

  test "should show product_product" do
    get product_product_url(@product_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_product_url(@product_product)
    assert_response :success
  end

  test "should update product_product" do
    patch product_product_url(@product_product), params: { product_product: { category: @product_product.category, code: @product_product.code, expiration_date: @product_product.expiration_date, name: @product_product.name, price: @product_product.price, product_product_type_id: @product_product.product_product_type_id, provider_provider_id: @product_product.provider_provider_id, publication_date: @product_product.publication_date, speciality_id: @product_product.speciality_id, status: @product_product.status, terms: @product_product.terms, user_created_id: @product_product.user_created_id, user_updated_id: @product_product.user_updated_id, valid_since: @product_product.valid_since, valid_until: @product_product.valid_until } }
    assert_redirected_to product_product_url(@product_product)
  end

  test "should destroy product_product" do
    assert_difference('Product::Product.count', -1) do
      delete product_product_url(@product_product)
    end

    assert_redirected_to product_products_url
  end
end
