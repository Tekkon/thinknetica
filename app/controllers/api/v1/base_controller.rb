require "application_responder"

class Api::V1::BaseController < ActionController::Base
  before_action :doorkeeper_authorize!

  self.responder = ApplicationResponder
  respond_to :json

  protect_from_forgery with: :null_session

  def current_ability
    @current_ability ||= Ability.new(current_resource_owner)
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
