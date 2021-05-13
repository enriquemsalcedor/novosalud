require 'test_helper'

class MotivesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @motive = motives(:one)
  end

  test "should get index" do
    get motives_url
    assert_response :success
  end

  test "should get new" do
    get new_motive_url
    assert_response :success
  end

  test "should create motive" do
    assert_difference('Motive.count') do
      post motives_url, params: { motive: { id_user_mod: @motive.id_user_mod, id_user_reg: @motive.id_user_reg, name: @motive.name, status: @motive.status } }
    end

    assert_redirected_to motive_url(Motive.last)
  end

  test "should show motive" do
    get motive_url(@motive)
    assert_response :success
  end

  test "should get edit" do
    get edit_motive_url(@motive)
    assert_response :success
  end

  test "should update motive" do
    patch motive_url(@motive), params: { motive: { id_user_mod: @motive.id_user_mod, id_user_reg: @motive.id_user_reg, name: @motive.name, status: @motive.status } }
    assert_redirected_to motive_url(@motive)
  end

  test "should destroy motive" do
    assert_difference('Motive.count', -1) do
      delete motive_url(@motive)
    end

    assert_redirected_to motives_url
  end
end
