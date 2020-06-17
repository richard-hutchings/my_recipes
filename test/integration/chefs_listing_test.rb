require 'test_helper'

class ChefsListingTest < ActionDispatch::IntegrationTest
  
   def setup
      @chef = Chef.create!(chefname: "Richard", email: "richard@example.com",
                          password: "password", password_confirmation: "password")
      @chef2 = Chef.create!(chefname: "Jamie", email: "jamie@example.com",
                            password: "password", password_confirmation: "password")
   end 
   
    test "should get chefs listing" do
    get chefs_path
    assert_template 'chefs/index'
    assert_select "a[href=?]", chef_path(@chef), text: @chef.name.capitalize 
    assert_select "a[href=?]", chef_path(@chef2), text: @chef2.name.capitalize
  end
  
  test "should delete chef" do 
      get 'chefs_path'
      assert_template 'chefs/index'
      assert_difference 'Chef.count', -1 do 
          delete chef_path(@chef3)
      end 
      assert_redirected_to chefs_path
      assert_not flash.empty?
  end 
end
