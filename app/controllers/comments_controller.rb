# CommentsController
# This controller manages comments related to posts. It includes actions for retrieving, creating,
# updating, and deleting comments. Admin-specific actions are also available.

class CommentsController < ApplicationController
  before_action :set_user_and_post, except: [:index, :admin_remove]
  before_action :set_comment, except: [:create, :index]

  # GET /comments
  # Returns a list of comments based on the user's role.
  def index
    @user = authenticate_user

    if @user.role == "admin"
      @comments = Comment.all
      render json: @comments
    elsif @user.role == "user"
      comments = @user.comments.all
      render json: comments
    end
  end

  # POST /comments
  # Creates a new comment for a post by the authenticated user.
  # Returns a JSON response indicating whether the comment was successfully created.
  def create
    @comment = @post.comments.new(comments_params)

    if @comment.save
      render json: { messages: "comment created for post by user" }
    else
      render json: { messages: "comment not created" }
    end
  end

  # GET /comments/:id
  # Returns details of a specific comment.
  def show
    render json: @comment
  end

  # PATCH/PUT /comments/:id
  # Updates an existing comment based on the provided parameters.
  # Returns a JSON response indicating whether the comment was successfully updated.
  def update
    if @comment.update(comments_params)
      render json: { messages: "comment updated successfully" }
    else
      render json: { messages: "comment not updated" }
    end
  end

  # DELETE /comments/:id
  # Deletes a specific comment.
  # Returns a JSON response indicating whether the comment was successfully deleted.
  def destroy
    if @comment.destroy
      render json: { messages: "comment deleted" }
    else
      render json: { messages: "comment not deleted" }
    end
  end

  # DELETE /comments/admin_remove/:id
  # Admin-only action to remove a comment from the site.
  # Returns a JSON response indicating whether the comment was successfully removed.
  def admin_remove
    @user = authenticate_user

    if @user.role == "admin"
      comment = Comment.find(params[:id])

      if comment.destroy
        render json: { messages: "comment removed from this site successfully by admin" }
      else
        render json: { messages: "there is an issue that caused the comment not to be removed" }
      end
    else
      render json: { messages: "user is not admin" }
    end
  end

  public

  # Strong parameters for the 'comment' model.
  def comments_params
    params.require(:comment).permit(:author, :content, :posteddate, :post_id).merge(user_id: authenticate_user.id)
  end

  # Private: Sets the @user and @post instance variables based on the authenticated user and post_id parameter.
  # Renders a JSON response if an error occurs during the process.
  def set_user_and_post
    begin
      @user = authenticate_user
      @post = @user.posts.find(params[:post_id])
    rescue
      render json: { messages: "something went wrong, can't find post to comment" }
    end
  end

  # Private: Sets the @comment instance variable based on the id parameter.
  def set_comment
    @comment = Comment.find(params[:id])
  end
end
