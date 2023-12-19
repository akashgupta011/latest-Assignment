class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  def show
    render json: @post  
  end

  def create
    @user = authenticate_user
    @post = @user.posts.new(post_params)
    if @post.save 
      render json: @post, include: [:image]
    else
      render json: { messages: 'Something went wrong. Please check and try again.' }
    end
  end

  def update
    if @post.update(post_params)
      render json: @post, notice: 'Post was successfully updated.'
    else
      render json: { messages: 'Post not updated.' }
    end
  end

  def destroy
    if @post.destroy
      render json: { messages: 'Post deleted successfully.' }
    else
      render json: { messages: 'Post was not destroyed yet.' }
    end
  end

  def filter
    posts = if params[:Category].present?
              Post.where(Category: params[:Category])
            elsif params[:tag].present?
              Post.where(tag: params[:tag])
            elsif params[:title].present?
              Post.where(title: params[:title])
            else
              Post.all
            end

    render json: posts
  end

  def search
    # Your search logic here
  end

  private

  def set_post
    begin
      @user = authenticate_user
      @post = @user.posts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { message: 'No post available with the given ID.' }, status: :not_found
    end
  end

  def post_params
    params.require(:post).permit(:title, :content, :author, :Category, :tag, :published_date, :image).merge(user_id: authenticate_user.id)
  end
end
