module Commented
  extend ActiveSupport::Concern

  included do
    before_action :load_commentable, only: [:comment]
    after_action :publish_comment, only: [:comment]
  end

  def comment
    respond_to do |format|
      format.json do
        @comment = @commentable.comments.build(comment_params)
        @comment.user = current_user

        if @comment.save
          render json: { comment: @comment.as_json(include: :user) }
        else
          render json: { commentable_id: @commentable.id, errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def load_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?

    result = { comment: @comment.as_json(include: :user) }

    id = @comment.commentable.try(:question) ? @comment.commentable.question.id : @comment.commentable.id
    ActionCable.server.broadcast("comments/question_#{id}", result)
    ActionCable.server.broadcast("comments", { comment: @comment.as_json(include: :user) })
  end
end
