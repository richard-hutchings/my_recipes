require 'test_helper'

class RecipesDeleteTest < ActionDispatch::IntegrationTest
 
  def setup
    @chef = Chef.create!(chefname: "Richard", email: "richard@example.com",
                        password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "The Perfect Egg", description: "Place egg into simmering water, turn up to a rolli...", chef: @chef)
  end
  
  test 'successfully delete a recipe' do
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_select 'a[href=?]', recipe_path(@recipe), text: 'Delete this Recipe?'
    assert_difference 'Recipe.count', -1 do 
      delete recipe_path(@recipe)
    end
    assert_redirected_to 'recipe_path'
    assert_not flash.empty?
  end
end
