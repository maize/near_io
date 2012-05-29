require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  test "should get get_notes_by_longitude_latitude" do
    get :get_notes_by_longitude_latitude
    assert_response :success
  end

  test "should get add_notes_by_text" do
    get :add_notes_by_text
    assert_response :success
  end

end
