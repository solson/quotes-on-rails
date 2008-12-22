require File.dirname(__FILE__) + '/../helper'

RE_Admin      = %r{(?:(?:the )? *(\w+) *)}
RE_Admin_TYPE = %r{(?: *(\w+)? *)}
steps_for(:admin) do

  #
  # Setting
  #
  
  Given "an anonymous admin" do 
    log_out!
  end

  Given "$an $admin_type admin with $attributes" do |_, admin_type, attributes|
    create_admin! admin_type, attributes.to_hash_from_story
  end
  
  Given "$an $admin_type admin named '$login'" do |_, admin_type, login|
    create_admin! admin_type, named_admin(login)
  end
  
  Given "$an $admin_type admin logged in as '$login'" do |_, admin_type, login|
    create_admin! admin_type, named_admin(login)
    log_in_admin!
  end
  
  Given "$actor is logged in" do |_, login|
    log_in_admin! @admin_params || named_admin(login)
  end
  
  Given "there is no $admin_type admin named '$login'" do |_, login|
    @admin = Admin.find_by_login(login)
    @admin.destroy! if @admin
    @admin.should be_nil
  end
  
  #
  # Actions
  #
  When "$actor logs out" do 
    log_out
  end

  When "$actor registers an account as the preloaded '$login'" do |_, login|
    admin = named_admin(login)
    admin['password_confirmation'] = admin['password']
    create_admin admin
  end

  When "$actor registers an account with $attributes" do |_, attributes|
    create_admin attributes.to_hash_from_story
  end
  

  When "$actor logs in with $attributes" do |_, attributes|
    log_in_admin attributes.to_hash_from_story
  end
  
  #
  # Result
  #
  Then "$actor should be invited to sign in" do |_|
    response.should render_template('/sessions/new')
  end
  
  Then "$actor should not be logged in" do |_|
    controller.logged_in?.should_not be_true
  end
    
  Then "$login should be logged in" do |login|
    controller.logged_in?.should be_true
    controller.current_admin.should === @admin
    controller.current_admin.login.should == login
  end
    
end

def named_admin login
  admin_params = {
    'admin'   => {'id' => 1, 'login' => 'addie', 'password' => '1234addie', 'email' => 'admin@example.com',       },
    'oona'    => {          'login' => 'oona',   'password' => '1234oona',  'email' => 'unactivated@example.com'},
    'reggie'  => {          'login' => 'reggie', 'password' => 'monkey',    'email' => 'registered@example.com' },
    }
  admin_params[login.downcase]
end

#
# Admin account actions.
#
# The ! methods are 'just get the job done'.  It's true, they do some testing of
# their own -- thus un-DRY'ing tests that do and should live in the admin account
# stories -- but the repetition is ultimately important so that a faulty test setup
# fails early.  
#

def log_out 
  get '/sessions/destroy'
end

def log_out!
  log_out
  response.should redirect_to('/')
  follow_redirect!
end

def create_admin(admin_params={})
  @admin_params       ||= admin_params
  post "/admins", :admin => admin_params
  @admin = Admin.find_by_login(admin_params['login'])
end

def create_admin!(admin_type, admin_params)
  admin_params['password_confirmation'] ||= admin_params['password'] ||= admin_params['password']
  create_admin admin_params
  response.should redirect_to('/')
  follow_redirect!

end



def log_in_admin admin_params=nil
  @admin_params ||= admin_params
  admin_params  ||= @admin_params
  post "/session", admin_params
  @admin = Admin.find_by_login(admin_params['login'])
  controller.current_admin
end

def log_in_admin! *args
  log_in_admin *args
  response.should redirect_to('/')
  follow_redirect!
  response.should have_flash("notice", /Logged in successfully/)
end
