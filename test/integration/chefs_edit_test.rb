require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
   @chef = Chef.create!(chefname: "Richard", email: "richard@example.com",
                        password: "password", password_confirmation: "password")
  end 
  
   test "reject an invalid edit" do 
      sign_in_as(@chef, "password")
      get edit_chef_path(@chef) 
      assert_template 'chefs/edit'
      patch chef_path, params: { chef: { chefname: " ", email: "richard@example.com"  } } 
      assert_template 'chefs/edit'
      assert_select 'h2.panel-title'
      assert_select 'div.panel-body'
    end 
    
    test "accept valid signup" do 
      sign_in_as(@chef, "password")
      get edit_chef_path(@chef) 
      assert_template 'chefs/edit'
      patch chef_path, params: { chef: { chefname: "Richard3", email: "richard3@example.com"  } }
      assert_redirected_to @chef
      assert_not flash.empty?
      @chef.reload
      assert_match "Richard3", @chef.chefname
      assert_match "richard3@example.com", @chef.email
    end 
end
