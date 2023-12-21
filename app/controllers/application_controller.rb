# ApplicationController
# This is a base controller class for your Rails application, inheriting from ActionController::API.
# It contains methods related to user authentication using JSON Web Tokens (JWT).

class ApplicationController < ActionController::API
  # Public: Authenticates a user based on the provided JSON Web Token (JWT) in the 'Authorization' header.
  #
  # Returns the authenticated user if the token is valid and the user is found.
  # Renders a JSON response with an 'unauthorized' status if the token is invalid or the user is not found.
  #
  # Example:
  #   authenticated_user = authenticate_user
  #
  # Note: This method assumes the presence of an 'Authorization' header containing a valid JWT.
  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = decode_token(token)

    if decoded_token
      user_id = decoded_token["user_id"]
      user = User.find_by(id: user_id)

      if user
        return user
      else
        render_unauthorized
      end
    else
      render_unauthorized
    end
  end

  private

  # Private: Decodes a JSON Web Token (JWT) and returns the decoded payload.
  #
  # token - The JWT to be decoded.
  #
  # Returns the decoded payload as a Hash if the decoding is successful.
  # Returns nil if the token is nil or decoding fails.
  #
  # Example:
  #   decoded_payload = decode_token(token)
  #
  # Note: This method expects a JWT format with a header, payload, and signature separated by dots.
  def decode_token(token)
    return nil unless token

    header, payload, signature = token.split('.')
    decoded_payload = Base64.decode64(payload)
    return JSON.parse(decoded_payload)
  rescue StandardError
    nil
  end

  # Private: Renders a JSON response indicating unauthorized access.
  #
  # Renders a JSON response with an 'unauthorized' status and an 'error' key.
  #
  # Example:
  #   render_unauthorized
  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
