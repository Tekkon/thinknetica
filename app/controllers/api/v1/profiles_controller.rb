class Api::V1::ProfilesController < Api::V1::BaseController
  def index
    respond_with User.where('id != ?', current_resource_owner.id)
  end

  def me
    respond_with current_resource_owner
  end
end
