require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get index" do
  	dave = users(:dave)
  	session[:user_id] = dave.id
    get :index
    assert_response :success
    assert_not_nil assigns(@user)
  end

end
