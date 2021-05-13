require 'test_helper'

class Territory::AddressesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @territory_address = territory_addresses(:one)
  end

  test "should get index" do
    get territory_addresses_url
    assert_response :success
  end

  test "should get new" do
    get new_territory_address_url
    assert_response :success
  end

  test "should create territory_address" do
    assert_difference('Territory::Address.count') do
      post territory_addresses_url, params: { territory_address: { description: @territory_address.description, territory_city_id: @territory_address.territory_city_id, territory_country_id: @territory_address.territory_country_id, territory_state_id: @territory_address.territory_state_id } }
    end

    assert_redirected_to territory_address_url(Territory::Address.last)
  end

  test "should show territory_address" do
    get territory_address_url(@territory_address)
    assert_response :success
  end

  test "should get edit" do
    get edit_territory_address_url(@territory_address)
    assert_response :success
  end

  test "should update territory_address" do
    patch territory_address_url(@territory_address), params: { territory_address: { description: @territory_address.description,  territory_city_id: @territory_address.territory_city_id, territory_country_id: @territory_address.territory_country_id, territory_state_id: @territory_address.territory_state_id } }
    assert_redirected_to territory_address_url(@territory_address)
  end

  test "should destroy territory_address" do
    assert_difference('Territory::Address.count', -1) do
      delete territory_address_url(@territory_address)
    end

    assert_redirected_to territory_addresses_url
  end
end
