class ApplicationController < ActionController::Base
  include SessionsHelper
  def hello
    render html: 'hello, world!'
  end

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end
end
