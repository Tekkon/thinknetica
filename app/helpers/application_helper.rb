module ApplicationHelper
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource_class
    User
  end

  def resource_name
    :user
  end
end
