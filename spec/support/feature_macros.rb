module FeatureMacros

  def sign_in
    Fabricate(:user, name: 'Tom Taylor', email: 'tom@tom.com', password: 'password')
    visit sign_in_path
    fill_in 'Email', with: 'tom@tom.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign In'
  end


end