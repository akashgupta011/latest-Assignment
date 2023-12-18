class PostsController < ApplicationController
  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks

  before_action :set_post, only: [:show, :update, :destroy]

  def show
    render json: @post  
  end

  def create
    @user = authenticate_user
    @post = @user.posts.new(post_params)
    # debugger
    # @post.image(io: File.open('/home/blubirch/Pictures/image.png'), filename: 'image.png')
    if @post.save 
      render json: @post, include: [:image]
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
    if params[:Category].present?
      posts = Post.find_by_Category(params[:Category])
    elsif params[:tag].present?
      posts = Post.find_by_tag(params[:tag])
    if params[:title].present?
      posts = Post.find_by_title(params[:title])
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
    params.require(:post).permit(:title, :content, :author, :published_date, :image, :Category, :tag).merge(user_id: authenticate_user.id)#.merge(tag_ids: [1])
  end
end
