module VotablesHelper
  def vote_description(votable, user)
    "You have voted #{votable.vote(user).vote_type == 1 ? 'for' : 'against'} this #{votable.class.name.downcase}."
  end
end
