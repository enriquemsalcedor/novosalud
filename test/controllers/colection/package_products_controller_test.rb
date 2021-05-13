require 'test_helper'

class Colection::PackageProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @colection_package_product = colection_package_products(:one)
  end

  test "should get index" do
    get colection_package_products_url
    assert_response :success
  end

  test "should get new" do
    get new_colection_package_product_url
    assert_response :success
  end

  test "should create colection_package_product" do
    assert_difference('Colection::PackageProduct.count') do
      post colection_package_products_url, params: { colection_package_product: { colection_package_id: @colection_package_product.colection_package_id, product_product_id: @colection_package_product.product_product_id, quantity: @colection_package_product.quantity, user_created_id: @colection_package_product.user_created_id, user_updated_id: @colection_package_product.user_updated_id } }
    end

    assert_redirected_to colection_package_product_url(Colection::PackageProduct.last)
  end

  test "should show colection_package_product" do
    get colection_package_product_url(@colection_package_product)
    assert_response :success
  end

  test "should get edit" do
    get edit_colection_package_product_url(@colection_package_product)
    assert_response :success
  end

  test "should update colection_package_product" do
    patch colection_package_product_url(@colection_package_product), params: { colection_package_product: { colection_package_id: @colection_package_product.colection_package_id, product_product_id: @colection_package_product.product_product_id, quantity: @colection_package_product.quantity, user_created_id: @colection_package_product.user_created_id, user_updated_id: @colection_package_product.user_updated_id } }
    assert_redirected_to colection_package_product_url(@colection_package_product)
  end

  test "should destroy colection_package_product" do
    assert_difference('Colection::PackageProduct.count', -1) do
      delete colection_package_product_url(@colection_package_product)
    end

    assert_redirected_to colection_package_products_url
  end
end
