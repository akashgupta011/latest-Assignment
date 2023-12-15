class CommentsController < ApplicationController
  before_action :set_user_and_post
  before_action :set_comment, except: [:create]
  
  def create
    @comment = @post.comments.new(comments_params)
    debugger
    if @comment.save
      render json: {messages:"comment created for post by user"}
    else
      render json:{messages:"comment not created"}
    end
  end
  
  def show
    render json: @comment
  end
  
  def update
    if @comment.update(comments_params)
      render json:{messages: "comment updated successfully"}
    else
      render json:{messages:"comment not updated"}
    end
  end
  
  def destroy
    if @comment.destroy
      render json:{messages:"comment deleted"}
    else
      render json:{messages:"comment not deleted"}
    end
  end
  
  public
    
    def comments_params
      params.require(:comment).permit(:author, :content, :posteddate, :post_id).merge(user_id: authenticate_user.id)
    end
    
    def set_user_and_post
      begin
        @user = authenticate_user
        @post = @user.posts.find(params[:post_id])
      rescue
        render json:{messages:"something went wrong can't find post to comment"}
      end
    end
    
    def set_comment
      @comment = Comment.find(params[:id])
    end

end