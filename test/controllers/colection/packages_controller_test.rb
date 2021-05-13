require 'test_helper'

class Colection::PackagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @colection_package = colection_packages(:one)
  end

  test "should get index" do
    get colection_packages_url
    assert_response :success
  end

  test "should get new" do
    get new_colection_package_url
    assert_response :success
  end

  test "should create colection_package" do
    assert_difference('Colection::Package.count') do
      post colection_packages_url, params: { colection_package: { description: @colection_package.description, status: @colection_package.status, total_amount: @colection_package.total_amount, user_created_id: @colection_package.user_created_id, user_updated_id: @colection_package.user_updated_id, valid_since: @colection_package.valid_since, valid_until: @colection_package.valid_until } }
    end

    assert_redirected_to colection_package_url(Colection::Package.last)
  end

  test "should show colection_package" do
    get colection_package_url(@colection_package)
    assert_response :success
  end

  test "should get edit" do
    get edit_colection_package_url(@colection_package)
    assert_response :success
  end

  test "should update colection_package" do
    patch colection_package_url(@colection_package), params: { colection_package: { description: @colection_package.description, status: @colection_package.status, total_amount: @colection_package.total_amount, user_created_id: @colection_package.user_created_id, user_updated_id: @colection_package.user_updated_id, valid_since: @colection_package.valid_since, valid_until: @colection_package.valid_until } }
    assert_redirected_to colection_package_url(@colection_package)
  end

  test "should destroy colection_package" do
    assert_difference('Colection::Package.count', -1) do
      delete colection_package_url(@colection_package)
    end

    assert_redirected_to colection_packages_url
  end
end
