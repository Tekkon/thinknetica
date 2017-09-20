class Question < ApplicationRecord
  include Attachmentable
  include Votable
  include Commentable

  after_create :create_subscription

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  belongs_to :user

  validates :title, :body, presence: true

  private

  def create_subscription
    Subscription.create(question: self, user: self.user)
  end
end
