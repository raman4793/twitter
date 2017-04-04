class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      log_in user
      user.update(last_login_at: DateTime.now)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      result = request.location
      UserLogin.create(user_id: user.id,ip: request.remote_ip, user_agent: request.user_agent, country: result.country, city: result.city)
      # puts("#{user.name} logged in from #{request.remote_ip} from #{request.user_agent} from #{result}")
      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    current_user.update(last_logout_at: DateTime.now)
    log_out if logged_in?
    redirect_to root_url
  end
end
