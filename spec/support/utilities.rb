def sign_in(user)
  visit signin_path
  fill_in "Username",    with: user.username
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:auth_token] = user.auth_token
end
