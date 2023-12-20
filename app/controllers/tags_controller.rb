# TagsController
# This controller manages tags. It includes actions for retrieving, creating, updating, and deleting tags.

class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :update, :destroy]

  # GET /tags
  # Returns a list of all tags.
  def index
    @tags = Tag.all
    render json: @tags
  end

  # POST /tags
  # Creates a new tag based on the provided parameters.
  # Returns a JSON response indicating whether the tag was successfully created.
  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      render json: @tag, status: :created
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # GET /tags/:id
  # Returns details of a specific tag.
  def show
    render json: @tag
  end

  private

  # Private: Sets the @tag instance variable based on the id parameter.
  def set_tag
    @tag = Tag.find(params[:id])
  end

  # Private: Strong parameters for the 'tag' model.
  def tag_params
    params.require(:tag).permit(:name)
  end
end
