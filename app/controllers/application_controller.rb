class ApplicationController < ActionController::Base
  protect_from_forgery

  def authentication
    if session[:user].nil?
      session[:last_url] = request.url
      redirect_to login_path
    end
  end
end
