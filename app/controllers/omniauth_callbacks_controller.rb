class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      authenticate('Facebook')
    end
  end

  def twitter
    auth = request.env['omniauth.auth']

    @user = User.find_for_oauth(auth)

    if @user.persisted?
      authenticate('Twitter')
    else
      @user = User.create_user_and_auth(Faker::Internet.email, auth.provider, auth.uid)
      render 'users/email_form', locals: { user: @user }, layout: false
    end
  end

  private

  def authenticate(kind)
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
  end
end
