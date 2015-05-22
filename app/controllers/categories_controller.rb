class CategoriesController < ApplicationController
  
  before_action :require_user

  def show
    @category = Category.first
  end
  

end