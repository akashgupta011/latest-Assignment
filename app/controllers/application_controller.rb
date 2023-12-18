class ApplicationController < ActionController::API
  def authenticate_user
    token = request.headers['Authorization']&.split(' ')&.last
    decoded_token = decode_token(token)
    json_data = JSON.parse(decoded_token)
    user_id = json_data["user_id"]
    user = User.find_by_id(user_id)
    if user
      return user
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private
  def decode_token(token)
    # jwt = user.token
    header, payload, signature = token.split('.')
    decoded_payload = Base64.decode64(payload)
    return decoded_payload
  end
end
