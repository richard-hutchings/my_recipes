require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest
 
  def setup
    @chef = Chef.create!(chefname: "Richard", email: "richard@example.com",
                        password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "The Perfect Egg", description: "Place egg into simmering water, turn up to a rolli...", chef: @chef)
    @recipe3 = @chef.recipes.build(name: "pizza", description: "Pizza is awesome but heavy on the belly")
    @recipe3.save
  end
  
  test 'should get chefs show' do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe3), text: @recipe3.name 
    assert_match @recipe.description, response.body
    assert_match @recipe3.description, response.body 
    assert_match @chef.chefname, response.body 
  end
end
