class CallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if signed_in?
      redirect_to root_path
    else
      sign_in_and_redirect @user
    end
  end
end
