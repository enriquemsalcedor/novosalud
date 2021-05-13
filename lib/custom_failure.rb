class CustomFailure < Devise::FailureApp
  def redirect_url
    if session[:layout] == 'admin'
      admin_path
    else
      new_user_session_path
    end
  end
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end