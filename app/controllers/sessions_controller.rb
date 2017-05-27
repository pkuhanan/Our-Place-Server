class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create], raise: false

  def create
    if user = User.valid_login?(params[:email], params[:password])
      allow_token_to_be_used_only_once_for(user)
      return_user_for_valid_login_of(user)
    else
      render_unauthorized("Error with your login or password")
    end
  end

  def destroy
    logout
    head :ok
  end

  private

  def return_user_for_valid_login_of(user)
    render json: user.attributes.slice("token", "email", "id")
  end

  def allow_token_to_be_used_only_once_for(user)
    user.regenerate_token
  end

  def logout
    current_user.invalidate_token
  end
end