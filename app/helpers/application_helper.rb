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

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:uts).try(:to_s)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end
end
