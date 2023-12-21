# app/controllers/categories_controller.rb
class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy]

  # GET /categories
  # Returns a JSON array of all categories.
  def index
    @categories = Category.all
    render json: @categories
  end

  # POST /categories
  # Creates a new category with the provided parameters.
  # Returns the created category as JSON if successful.
  # Returns the errors as JSON with an 'unprocessable_entity' status if unsuccessful.
  def create
    @category = Category.new(category_params)

    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # Private method to set the @category instance variable before certain actions.
  # Used as a 'before_action' callback.
  private

  # Sets the @category instance variable based on the 'id' parameter.
  # Renders a JSON response with an 'not_found' status if the category is not found.
  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Category not found' }, status: :not_found
  end

  # Strong parameters for the 'category' model.
  def category_params
    params.require(:category).permit(:name)
  end
end
