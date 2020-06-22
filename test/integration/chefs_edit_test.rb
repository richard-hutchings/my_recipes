require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "Richard", email: "richard@example.com",
                        password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "Jamie", email: "jamie@example.com",
                        password: "password", password_confirmation: "password")
    @admin_user = Chef.create!(chefname: "Jamie3", email: "jamie3@example.com",
                        password: "password", password_confirmation: "password", admin: true)
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
    
    test "accept valid edit" do 
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
    
    test "accept edit attempt by admin user" do 
      sign_in_as(@admin_user, "password")
      get edit_chef_path(@chef) 
      assert_template 'chefs/edit'
      patch chef_path, params: { chef: { chefname: "Jamie3", email: "jamie3@example.com"  } }
      assert_redirected_to @chef
      assert_not flash.empty?
      @chef.reload
      assert_match "jamie3", @chef.chefname
      assert_match "jamie3@example.com", @chef.email
    end 
    
    test "redirect edit attempt by non-admin user" do 
      sign_in_as(@chef2, "password")
      updated_name = "joe"
      updated_email = "joe@example.com"
      patch chef_path, params: { chef: { chefname: updated_name, email: updated_email  } }
      assert_redirected_to chefs_path
      assert_not flash.empty?
      @chef.reload
      assert_match "Richard", @chef.chefname
      assert_match "richard@example.com", @chef.email
    end 
end
