class PostsController < ApplicationController
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  before_action :set_post, only: [:show, :update, :destroy]

  def show
    render json: @post 
  end

  def create
    @user = authenticate_user
    @post = @user.posts.new(post_params)
    if @post.save
      render json: {messages: 'Post was successfully created.'}
    else
      render json: {messages: 'something went wrong please check and try again'}
    end
  end

  def update
    if @post.update(post_params)
      render json: @post, notice: 'Post was successfully updated.'
    else
      render json: {messages:"post not updated"}
    end
  end

  def destroy
    if @post.destroy
      render json: {messages:"post deleted successfully"}
    else
      render json: {messages: 'Post was successfully not destroyed yet.'}
    end
  end

  def filter
    if params[:category_id].present?
      posts = Post.joins(:categories).where(categories: { id: params[:category_id] })
    elsif params[:tag_id].present?
      posts = Post.joins(:tags).where(tags: { id: params[:tag_id] })
    else
      posts = Post.all
    end

    render json: posts
  end

  private

  def set_post
    begin
      @user = authenticate_user
      @post = @user.posts.find(params[:id])
    rescue
      render json:{message:"no post available"}
    end
  end

  def post_params
    params.require(:post).permit(:title, :user_id, :content, :author, :published_date, :image, category_ids: [], tag_ids: [])
  end
end
