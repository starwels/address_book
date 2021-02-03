class ApplicationController < ActionController::API
  include Authenticable

  before_action :authenticate_user!

  attr_reader :current_user

  def current_user
    @current_user ||= get_current_user
  end
end
