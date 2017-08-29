module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
    accepts_nested_attributes_for :votes, reject_if: :all_blank
  end

  def vote(user)
    votes.where(user: user, votable: self).first
  end

  def vote_description(user)
    "You have voted #{vote(user).vote_type == 1 ? 'for' : 'against'} this #{self.class.name.downcase}."
  end
end
