class SearchController < ApplicationController
  def index
    respond_with(@result = Searcher.search(params[:object], params[:text]))
  end
end
