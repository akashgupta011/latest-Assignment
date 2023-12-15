class CommentsController < ApplicationController
  
  def create
    @comments.new(comments_params)
    if @comment.save
      render json: {messages:"comment created for post by user"}
    else
      render json:{messages:"comment not created"}
    end
  end
  
  def show
  end
  
  def update
  end
  
  def destroy
  end
  
  public
    def comments_params

    end
    def set_user_and_post
      @user = authenticate_user
      @post = @user.posts.find(params[:user_id])
      @comments = @post.comments(params[:id])
    end
end