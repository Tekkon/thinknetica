class UsersController < ApplicationController
  def finish_signup
    @user = User.find(params[:id])
    @another_user = User.find_by_email(params[:email])

    auth = @user.authorizations.first

    if @another_user
      @another_user.authorizations.create(provider: auth.provider, uid: auth.uid)
      @user.destroy
      user = @another_user
    else
      @user.update(email: params[:email])
      user = @user
    end

    sign_in_and_redirect user, event: :authentication
    flash[:notice] = "Successfully authenticated from #{auth.provider.capitalize} account."
  end

  def send_finish_signup_email
    OmniauthMailer.finish_signup_email(user_params[:id], user_params[:email]).deliver_later

    render 'email_confirmation', layout: false
  end

  private

  def user_params
    params.require(:user).permit(:id, :email)
  end
end
