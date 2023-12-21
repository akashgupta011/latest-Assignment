# PostsController
# This controller manages posts. It includes actions for retrieving, creating, updating,
# and deleting posts. Admin-specific actions are also available.

class PostsController < ApplicationController
  include ActionController::MimeResponds
  before_action :set_post, only: [:show, :update, :destroy]
    
  # GET /posts
  # Returns a list of posts based on the user's role.
  def send_daily_report
    @posts = Post.where("created_at >= ?", Time.zone.now.beginning_of_day)

    # Assuming you have a User model associated with posts
    recipients = User.where(role:"admin").pluck(:email).join(',')

    UserMailer.daily_post_report(recipients, @posts).deliver_now
  end
  def index
  respond_to do |format|
    format.html
    format.csv do
      # Fetch posts created before 12 PM today
      posts_created_before_12pm = Post.where('created_at < ?', Time.zone.today.beginning_of_day + 12.hours)
      send_data posts_created_before_12pm.to_csv, filename: "posts_created_before_12pm-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv"
    end
  end

  # Authenticate the user
  @user = authenticate_user

  if @user.role == "admin"
    # Fetch all posts for admin
    @posts = Post.all
    render json: @posts
  elsif @user.role == "user"
    # Fetch posts for a regular user
    posts = @user.posts.all
    render json: posts
  end
end


  # GET /posts/:id
  # Returns details of a specific post based on the user's role.
  def show
    if @user.role == "admin"
      @posts = Post.all
      render json: @posts
    elsif @user.role == "user"
      render json: @post
    else
      render json: { messages: "user role is undefined" }
    end
  end

  # POST /posts
  # Creates a new post for the authenticated user.
  # Returns a JSON response indicating whether the post was successfully created.
  def create
    @user = authenticate_user
    @post = @user.posts.new(post_params)

    if @post.save
      render json: @post, include: [:image]
    else
      render json: { messages: 'Something went wrong. Please check and try again.' }
    end
  end

  # PATCH/PUT /posts/:id
  # Updates an existing post based on the provided parameters.
  # Returns a JSON response indicating whether the post was successfully updated.
  def update
    if @post.update(post_params)
      render json: @post, notice: 'Post was successfully updated.'
    else
      render json: { messages: 'Post not updated.' }
    end
  end

  # DELETE /posts/:id
  # Deletes a specific post.
  # Returns a JSON response indicating whether the post was successfully deleted.
  def destroy
    if @post.destroy
      render json: { messages: 'Post deleted successfully.' }
    else
      render json: { messages: 'Post was not destroyed yet.' }
    end
  end

  # DELETE /posts/admin_remove/:id
  # Admin-only action to remove a post from the site.
  # Returns a JSON response indicating whether the post was successfully removed.
  def admin_remove
    if @user.role == "admin"
      post = Post.find(params[:id])

      if post.destroy
        render json: { messages: 'Post removed from this site successfully by admin' }
      else
        render json: { messages: 'There is an issue that caused the post not to be removed' }
      end
    else
      render json: { messages: 'User is not admin' }
    end
  end

  # GET /posts/filter
  # Filters posts based on specified parameters such as category_ids, tag_ids, or title.
  def filter
    posts = if params[:category_ids].present?
              Post.where(category_ids: params[:category_ids])
            elsif params[:tag_ids].present?
              Post.where(tag_ids: params[:tag_ids])
            elsif params[:title].present?
              Post.where(title: params[:title])
            else
              Post.all
            end

    render json: posts
  end

  # GET /posts/search
  # Placeholder for search logic (to be implemented).
  # def search
  #   if params[:query].present?
  #     @posts = Post.search(params[:query])
  #   else
  #     @posts = Post.all
  #   end

  #   render json: @posts
  # end
  #   # Process the results and return them to the user
  #   return results
  # end

  private

  # Private: Sets the @post instance variable based on the id parameter.
  # Renders a JSON response if an error occurs during the process.
  def set_post
    begin
      @user = authenticate_user
      @post = @user.posts.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { message: 'No post available with the given ID.' }, status: :not_found
    end
  end

  # Private: Strong parameters for the 'post' model.
  def post_params
    params.require(:post).permit(:title, :content, :published_date, :image, :author, category_ids: [], tag_ids: []).merge(user_id: authenticate_user.id)
  end
end
