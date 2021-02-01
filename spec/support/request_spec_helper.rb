module RequestSpecHelper
  def json_body
    @json_body ||= JSON.parse(response.body, symbolize_names: true)
  end

  def token_generator(user)
    JWT.encode({ sub: user.id }, Rails.application.credentials.read)
  end
end