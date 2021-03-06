class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :commons

  def commons
    @dones = Workload.dones
    @yous = current_user ? current_user.workloads : []
    @playings = Workload.playings
    @chattings= Workload.chattings
  end

  def current_user
    User.find_by(id: session[:user_id])
  end
end
