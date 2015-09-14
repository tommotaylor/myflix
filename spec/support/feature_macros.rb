module FeatureMacros

  def sign_in(a_user=nil)
    user = a_user || Fabricate(:user)
    visit sign_in_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'
  end

  def admin_sign_in(a_user=nil)
    user = a_user || Fabricate(:user, admin: true)
    visit sign_in_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'
  end


  def sign_out
    visit sign_out_path
  end
end