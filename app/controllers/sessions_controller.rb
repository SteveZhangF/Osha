class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        # 判断用户是否勾选remember me 复选框
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
      
      # 登入用户，然后重定向到用户的资料页面
    else
      flash[:danger] = 'Invalid email/password combination' # 不完全正确
      render 'new'    
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
