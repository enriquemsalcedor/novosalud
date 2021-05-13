require 'test_helper'

class PeopleControllerTest < ActionDispatch::IntegrationTest
  setup do
    @people = people(:one)
  end

  test "should get index" do
    get people_url
    assert_response :success
  end

  test "should get new" do
    get new_people_url
    assert_response :success
  end

  test "should create people" do
    assert_difference('people.count') do
      post people_url, params: { people: { cellphone: @people.cellphone,
       civilstatus: @people.civilstatus, datebirth: @people.datebirth, 
       email: @people.email, gender: @people.gender, identificationdocument: @people.identificationdocument,
       name: @people.name, phone: @people.phone, surname: @people.surname, territory_address_id: @people.territory_address_id,
        typeidentification: @people.typeidentification } }
    end

    assert_redirected_to people_url(People.last)
  end

  test "should show people" do
    get people_url(@people)
    assert_response :success
  end

  test "should get edit" do
    get edit_people_url(@people)
    assert_response :success
  end

  test "should update people" do
    patch people_url(@people), params: { people: { cellphone: @people.cellphone, civilstatus: @people.civilstatus, datebirth: @people.datebirth, email: @people.email, gender: @people.gender, identificationdocument: @people.identificationdocument, name: @people.name, phone: @people.phone, surname: @people.surname, territory_address_id: @people.territory_address_id, typeidentification: @people.typeidentification } }
    assert_redirected_to people_url(@people)
  end

  test "should destroy people" do
    assert_difference('People.count', -1) do
      delete people_url(@people)
    end

    assert_redirected_to people_url
  end
end
