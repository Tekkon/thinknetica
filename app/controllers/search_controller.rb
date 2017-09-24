class SearchController < ApplicationController
  include SearchHelper

  def index
    respond_with search(params[:object], params[:text])
  end
end
