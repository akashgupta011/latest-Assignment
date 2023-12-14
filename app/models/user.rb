class User < ApplicationRecord
  has_many :posts
  has_many :comments, through: :posts

  def authenticate(password)
    self.password == password
  end

  def self.generate_token(user)
    # Customizing the payload
    payload = { user_id: user.id }
    
    # Use a strong secret key for encryption
    secret_key = 'c8fa3cc38ed50b339ed516e5210dbff4dd486cce39467df8b345c278ca12013fb96382ce6ed5deb0bbfce746efe9e625cb86e5016e69e458e702b2202ee8b8ce'
    
    # Encrypt the token
    token = JWT.encode(payload, secret_key, 'HS256')
    
    # Return the encrypted token
    token
  end

 
  
  # def self.encode(payload, exp = 24.hours.from_now)
  #   payload[:exp] = exp.to_i
  #   SECRET_KEY = Rails.secret_key
  #   JWT.encode(payload, SECRET_KEY)
  # end

  # def self.decode(token)
  #   decoded = JWT.decode(token, SECRET_KEY)[0]
  #   HashWithIndifferentAccess.new(decoded)
  # rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
  #   nil
  # end
end
