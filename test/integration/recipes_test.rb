require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @chef = Chef.create!(chefname: "Richard", email: "richard@example.com",
                        password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "The Perfect Egg", description: "Place egg into simmering water, turn up to a rolli...", chef: @chef)
    @recipe3 = @chef.recipes.build(name: "pizza", description: "Pizza is awesome but heavy on the belly")
    @recipe3.save
  end
  
  test "should get recipes index" do
    get recipes_path
    assert_response :success
  end
  
  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name 
    assert_select "a[href=?]", recipe_path(@recipe3), text: @recipe3.name
  end
 

  test "should get recipes show" do
    get recipes_path(@recipe)
    assert_template 'recipes/show'
    assert_match @recipe.name, response.body
    assert_match @recipe.description, response.body
    assert_match @chef.chefname, response.body
    assert_select "a[href=?]", edit_recipe_path(@recipe), text: "Edit this Recipe"
    assert_select "a[href=?]", recipe_path(@recipe), text: "Delete this Recipe"
    assert_select "a[href=?]", recipes_path, text: "Return to Recipe Listing"
  end
  
  
  test "create new valid recipe" do
    get new_recipe_path
    assert_template 'recipes/new'
      name_of_recipe = "chicken saute"
      description_of_recipe = "add chicken, add vegetables, cook for 20 minutes, serve delicious meal"
    assert_difference 'Recipe.count', 1 do
    post recipes_path, params: { recipe: { name: name_of_recipe, description: description_of_recipe}}
   end
     follow_redirect!
     assert_match name_of_recipe.capitalize, response.body
     assert_match description_of_recipe, response.body
  end
  
  test " reject invalid reccipe submissions" do
     get new_recipe_path
     assert_template 'recipes/new'
     assert_no_difference 'Recipe.count' do 
       post recipes_path, params: { recipe: { name: " ", description: "" } }
     end
     assert_template 'recipes/new'
     assert_select 'h2.panel-title'
     assert_select 'div.panel-body'
  end 
end 

