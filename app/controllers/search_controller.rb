class SearchController < ApplicationController
  def index
    @result = []

    if params[:object] == 'all'
      source = ThinkingSphinx.search(params[:text], page: 1)
    else
      source = params[:object].classify.constantize.search(params[:text], page: 1)
    end

    if source
      source.each do |object|
        title = object.title if object.respond_to?(:title)
        title = object.body if object.respond_to?(:body)
        title = object.email if object.respond_to?(:email)

        body = object.body if object.respond_to?(:body)
        body = object.email if object.respond_to?(:email)

        if object.respond_to?(:question_id)
          id = object.question_id
        elsif object.respond_to?(:commentable_id)
          id = object.commentable_id
        else
          id = object.id
        end

        @result << { id: id, type: object.class.to_s, title: title, body: body }
      end
    end

    respond_with @result
  end
end
