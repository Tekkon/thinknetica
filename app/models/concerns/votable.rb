module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
    accepts_nested_attributes_for :votes, reject_if: :all_blank
  end

  def vote_by(user, vote_type)
    votes.create!(user: user, vote_type: vote_type)
  end

  def revote(user)
    votes.where(user: user).destroy_all
  end

  def vote(user)
    votes.where(user: user).first
  end

  def rating
    votes.map { |v| v.vote_type }.sum
  end
end
