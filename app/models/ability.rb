class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Attachment, Subscription]
    can [:update, :destroy], [Question, Answer, Comment], user: user
    can :destroy, Attachment, attachmentable: { user: user }
    can :mark_favorite, Answer, question: { user: user }
    can :comment, [Question, Answer]
    can :destroy, Subscription, user: user

    can [:vote_for, :vote_against], Votable do |votable|
      votable.user != user && !votable.vote_by(user)
    end

    can :revote, Votable do |votable|
      votable.vote_by(user)
    end
  end
end
