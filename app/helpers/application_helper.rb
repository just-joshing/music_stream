module ApplicationHelper
  def link_userbar(user_id = nil)
    userbar = []
    if user_id
      userbar << link_to(get_session_user.name, edit_path)
      userbar << link_to('Admin', admin_path) if get_session_user.is_admin?
      userbar << link_to('Logout', logout_path, method: :delete)
    else
      userbar << link_to('Sign-up', signup_path)
      userbar << link_to('Login', login_path)
    end
    userbar.join(" | ")
  end
end
