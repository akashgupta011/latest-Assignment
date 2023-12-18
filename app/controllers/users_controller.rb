class UsersController < ApplicationController
  before_action :set_authenticity, except: [:registeration, :login]

  def registeration #create
    @user = User.new(user_params)

    if @user.save
      render json: @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def login #start session
    if @user.present?
      render json: { message: 'Please log out first' }
    else
      @user = User.find_by(email: params[:email]) || User.find_by(username: params[:username])

      if @user && @user.authenticate(params[:password])
        token = User.generate_token(@user)
        response.headers['Authorization'] = "Bearer #{token}"
        @user.update(token: token)
        render json: {message:"#{@user.username} is loggedin as user successfully"}
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
  end

  def show #show user profile
    if @user.Role == "admin"
      @users = User.all
      render json: @users
    elsif @user.Role == "user"
      render json: @user
    else
      render json: {messages: "user not found"}
    end
  end

  def update #manage user profile
    if @user.update(user_params)
      render json: @user
    else
      render json:{messages:"something went wrong"}
    end
      
  end

  def log_out #destroy for deleting user
    if @user.update(token: nil)
      render json:{messages:"user logged out successfully"}
    else
      render json:{messages:"user not logged out"}
    end
  end

  def remove_user
    if @user.destroy
      render json:{messages:"user removed from this site successfully"}
    else
      render json:{messages:"user not removed"}
    end
  end

  def admin_remove
    user = User.find(params[:id])
    if user.destroy
      render json:{messages:"user removed from this site successfully by admin"}
    else
      render json:{messages:"there is issue that cause user not removed"}
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :userbio, :email, :token, :password).merge(Role: "user")
    end

    def set_authenticity
      begin
        @user = authenticate_user
      rescue
        render json:{messages:"user not authorised"}
      end
    end
end
