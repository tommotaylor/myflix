module ControllerMacros
  def set_current_user(user=nil)
    session[:user_id] = (user || Fabricate(:user).id)
  end

  def clear_current_user
    session[:user_id] = nil
  end
end