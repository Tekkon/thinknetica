require "application_responder"

class ApplicationController < ActionController::Base
  #include Pundit

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  before_action :gon_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js { render partial: 'shared/alert', locals: { error: exception.message }, status: :forbidden }
      format.json { render json: { error: exception.message }, status: :forbidden }
    end
  end

  #check_authorization

  private

  def gon_user
    gon.user_id = current_user.id if current_user
  end
end
