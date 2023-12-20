# UsersController
# This controller manages user-related actions such as registration, login, profile display,
# profile management, logout, and user removal.

class UsersController < ApplicationController
  before_action :set_authenticity, except: [:registration, :login]

  # POST /users/registration
  # Registers a new user with the provided parameters.
  # Returns a JSON response indicating whether the user was successfully registered.
  def registration
    @user = User.new(user_params)

    if @user.save
      render json: @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  # POST /users/login
  # Logs in a user with the provided email or username and password.
  # Returns a JSON response indicating whether the login was successful.
  def login
    if @user.present?
      render json: { message: 'Please log out first' }
    else
      @user = User.find_by(email: params[:email]) || User.find_by(username: params[:username])

      if @user && @user.authenticate(params[:password])
        token = User.generate_token(@user)
        response.headers['Authorization'] = "Bearer #{token}"
        @user.update(token: token)
        if @user.role == "admin"
          render json: { message: "#{@user.username} is logged in as admin successfully" }
        else
          render json: { message: "#{@user.username} is logged in as user successfully" }
        end
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  end

  # GET /users/show
  # Shows the user's profile based on the user's role.
  def show
    if @user.role == "admin"
      @users = User.all
      render json: @users
    elsif @user.role == "user"
      render json: @user
    else
      render json: { messages: "user not found" }
    end
  end

  # PATCH/PUT /users/update
  # Updates the user's profile based on the provided parameters.
  # Returns a JSON response indicating whether the user profile was successfully updated.
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: { messages: "something went wrong" }
    end
  end

  # DELETE /users/logout
  # Logs out the user by updating the user's token to nil.
  # Returns a JSON response indicating whether the user was successfully logged out.
  def log_out
    if @user.update(token: nil)
      render json: { messages: "user logged out successfully" }
    else
      render json: { messages: "user not logged out" }
    end
  end

  # DELETE /users/remove_user
  # Removes the user from the site.
  # Returns a JSON response indicating whether the user was successfully removed.
  def remove_user
    if @user.destroy
      render json: { messages: "user removed from this site successfully" }
    else
      render json: { messages: "user not removed" }
    end
  end

  # DELETE /users/admin_remove/:id
  # Admin-only action to remove a user from the site.
  # Returns a JSON response indicating whether the user was successfully removed by admin.
  def admin_remove
    user = User.find(params[:id])

    if user.destroy
      render json: { messages: "user removed from this site successfully by admin" }
    else
      render json: { messages: "there is an issue that caused the user not to be removed" }
    end
  end

  def filter
    users = if params[:username].present?
              User.where(username: params[:username])
            elsif params[:userbio].present?
              User.where(userbio: params[:userbio])
            elsif params[:email].present?
              User.where(email: params[:email])
            else
              User.all
            end

    render json: users
  end

  private

  # Private: Strong parameters for the 'user' model.
  def user_params
    params.require(:user).permit(:username, :userbio, :email, :token, :password).merge(role: "user")
  end

  # Private: Sets the @user instance variable based on the authentication result.
  # Renders a JSON response if an error occurs during the process.
  def set_authenticity
    begin
      @user = authenticate_user
    rescue
      render json: { messages: "user not authorized" }
    end
  end
end
