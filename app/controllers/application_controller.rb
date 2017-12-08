class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def hello
    render html: "hello, world!"
  end
  
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  private
  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end
end
