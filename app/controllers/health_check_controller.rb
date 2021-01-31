class HealthCheckController < ActionController::Base
  def index
    body = 'I am up and running!'

    respond_to do |format|
      format.json { render json: body, status: :ok }
      format.html { render html: body }
    end
  end
end