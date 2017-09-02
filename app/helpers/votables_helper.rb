module VotablesHelper
  def vote_description(votable, user)
    "You have voted #{votable.vote_by(user).vote_type == 1 ? 'for' : 'against'} this #{votable.class.name.downcase}."
  end
end
