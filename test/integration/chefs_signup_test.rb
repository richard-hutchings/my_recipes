require 'test_helper'

class ChefsSignupTest < ActionDispatch::IntegrationTest
 
    test "should get signup path" do
        get signup_path
        assert_response :success
    end
    
    test "reject an invalid signup" do 
      
    end 
    
    test "accept valid signup" do 
      
    end 
end
