class UsersAuthController < ApplicationController
  def change_email
    @user = User.find(user_params[:id])
    @another_user = User.find_by_email(user_params[:email])

    auth = @user.authorizations.first

    if @another_user
      @another_user.authorizations.create(provider: auth.provider, uid: auth.uid)
      @user.destroy
      user = @another_user
    else
      @user.update(user_params)
      user = @user
    end

    sign_in_and_redirect user, event: :authentication
    flash[:notice] = "Successfully authenticated from #{auth.provider.capitalize} account."
  end

  private

  def user_params
    params.require(:user).permit(:id, :email)
  end
end
