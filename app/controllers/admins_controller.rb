class AdminsController < ApplicationController
  
  before_filter :login_required

  # render new.rhtml
  def new
    @admin = Admin.new
  end
 
  def create
    logout_keeping_session!
    @admin = Admin.new(params[:admin])
    success = @admin && @admin.save
    if success && @admin.errors.empty?
            # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      self.current_admin = @admin # !! now logged in
            redirect_back_or_default('/')
      flash[:notice] = "New admin account successfully created."
    else
      flash[:error]  = "Admin account creation failed."
      render :action => 'new'
    end
  end
end
