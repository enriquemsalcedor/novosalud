require 'test_helper'

class Clinic::ClinicServiceControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get clinic_clinic_service_index_url
    assert_response :success
  end

end
