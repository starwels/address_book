module Authenticable
  def encode_token(payload)
    begin
      JWT.encode(payload, Rails.application.credentials.read)
    rescue JWT::EncodeError
      nil
    end
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
    define_current_entity('current_user')

  end

  def authenticate_admin!
    unauthorized_entity unless current_user.admin?
  end

  def get_current_user
    authenticate
  end

  def authenticate
    if decoded_token
      begin
        user_id = decoded_token[0]['sub']
        User.find(user_id)
      rescue ActiveRecorde::NotFound, JWT::DecodeError, JWT::EncodeError
        unauthorized_entity
      end
    end
  end

  def token_from_request_header
    request.headers["Authorization"]&.split&.last
  end

  def unauthorized_entity
    head(:unauthorized)
  end

  private

  def define_current_entity(getter_name)
    return if respond_to?(getter_name)

    memoization_var_name = "@_#{getter_name}"
    self.class.send(:define_method, getter_name) do
      unless instance_variable_defined?(memoization_var_name)
        resource = authenticate
        instance_variable_set(memoization_var_name, resource)
      end
      instance_variable_get(memoization_var_name)
    end
  end
end