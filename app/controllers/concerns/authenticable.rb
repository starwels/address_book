module Authenticable
  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.read)
  end

  def decoded_token
    if token_from_request_header
      begin
        JWT.decode(token_from_request_header, Rails.application.credentials.read, true)
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def authenticate_user!
    unauthorized_entity unless authenticate
  end

  def get_current_user
    authenticate
  end

  def authenticate
    if decoded_token
      begin
        user_id = decoded_token[0]['sub']
        User.find(user_id)
      rescue
        nil
      end
    end
  end

  def token_from_request_header
    request.headers["Authorization"]&.split&.last
  end

  def unauthorized_entity
    head(:unauthorized)
  end
end