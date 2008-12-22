require File.dirname(__FILE__) + '/../spec_helper'
  
# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe AdminsController do
  fixtures :admins

  it 'allows signup' do
    lambda do
      create_admin
      response.should be_redirect
    end.should change(Admin, :count).by(1)
  end

  


  it 'requires login on signup' do
    lambda do
      create_admin(:login => nil)
      assigns[:admin].errors.on(:login).should_not be_nil
      response.should be_success
    end.should_not change(Admin, :count)
  end
  
  it 'requires password on signup' do
    lambda do
      create_admin(:password => nil)
      assigns[:admin].errors.on(:password).should_not be_nil
      response.should be_success
    end.should_not change(Admin, :count)
  end
  
  it 'requires password confirmation on signup' do
    lambda do
      create_admin(:password_confirmation => nil)
      assigns[:admin].errors.on(:password_confirmation).should_not be_nil
      response.should be_success
    end.should_not change(Admin, :count)
  end

  it 'requires email on signup' do
    lambda do
      create_admin(:email => nil)
      assigns[:admin].errors.on(:email).should_not be_nil
      response.should be_success
    end.should_not change(Admin, :count)
  end
  
  
  
  def create_admin(options = {})
    post :create, :admin => { :login => 'quire', :email => 'quire@example.com',
      :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
  end
end

describe AdminsController do
  describe "route generation" do
    it "should route admins's 'index' action correctly" do
      route_for(:controller => 'admins', :action => 'index').should == "/admins"
    end
    
    it "should route admins's 'new' action correctly" do
      route_for(:controller => 'admins', :action => 'new').should == "/signup"
    end
    
    it "should route {:controller => 'admins', :action => 'create'} correctly" do
      route_for(:controller => 'admins', :action => 'create').should == "/register"
    end
    
    it "should route admins's 'show' action correctly" do
      route_for(:controller => 'admins', :action => 'show', :id => '1').should == "/admins/1"
    end
    
    it "should route admins's 'edit' action correctly" do
      route_for(:controller => 'admins', :action => 'edit', :id => '1').should == "/admins/1/edit"
    end
    
    it "should route admins's 'update' action correctly" do
      route_for(:controller => 'admins', :action => 'update', :id => '1').should == "/admins/1"
    end
    
    it "should route admins's 'destroy' action correctly" do
      route_for(:controller => 'admins', :action => 'destroy', :id => '1').should == "/admins/1"
    end
  end
  
  describe "route recognition" do
    it "should generate params for admins's index action from GET /admins" do
      params_from(:get, '/admins').should == {:controller => 'admins', :action => 'index'}
      params_from(:get, '/admins.xml').should == {:controller => 'admins', :action => 'index', :format => 'xml'}
      params_from(:get, '/admins.json').should == {:controller => 'admins', :action => 'index', :format => 'json'}
    end
    
    it "should generate params for admins's new action from GET /admins" do
      params_from(:get, '/admins/new').should == {:controller => 'admins', :action => 'new'}
      params_from(:get, '/admins/new.xml').should == {:controller => 'admins', :action => 'new', :format => 'xml'}
      params_from(:get, '/admins/new.json').should == {:controller => 'admins', :action => 'new', :format => 'json'}
    end
    
    it "should generate params for admins's create action from POST /admins" do
      params_from(:post, '/admins').should == {:controller => 'admins', :action => 'create'}
      params_from(:post, '/admins.xml').should == {:controller => 'admins', :action => 'create', :format => 'xml'}
      params_from(:post, '/admins.json').should == {:controller => 'admins', :action => 'create', :format => 'json'}
    end
    
    it "should generate params for admins's show action from GET /admins/1" do
      params_from(:get , '/admins/1').should == {:controller => 'admins', :action => 'show', :id => '1'}
      params_from(:get , '/admins/1.xml').should == {:controller => 'admins', :action => 'show', :id => '1', :format => 'xml'}
      params_from(:get , '/admins/1.json').should == {:controller => 'admins', :action => 'show', :id => '1', :format => 'json'}
    end
    
    it "should generate params for admins's edit action from GET /admins/1/edit" do
      params_from(:get , '/admins/1/edit').should == {:controller => 'admins', :action => 'edit', :id => '1'}
    end
    
    it "should generate params {:controller => 'admins', :action => update', :id => '1'} from PUT /admins/1" do
      params_from(:put , '/admins/1').should == {:controller => 'admins', :action => 'update', :id => '1'}
      params_from(:put , '/admins/1.xml').should == {:controller => 'admins', :action => 'update', :id => '1', :format => 'xml'}
      params_from(:put , '/admins/1.json').should == {:controller => 'admins', :action => 'update', :id => '1', :format => 'json'}
    end
    
    it "should generate params for admins's destroy action from DELETE /admins/1" do
      params_from(:delete, '/admins/1').should == {:controller => 'admins', :action => 'destroy', :id => '1'}
      params_from(:delete, '/admins/1.xml').should == {:controller => 'admins', :action => 'destroy', :id => '1', :format => 'xml'}
      params_from(:delete, '/admins/1.json').should == {:controller => 'admins', :action => 'destroy', :id => '1', :format => 'json'}
    end
  end
  
  describe "named routing" do
    before(:each) do
      get :new
    end
    
    it "should route admins_path() to /admins" do
      admins_path().should == "/admins"
      formatted_admins_path(:format => 'xml').should == "/admins.xml"
      formatted_admins_path(:format => 'json').should == "/admins.json"
    end
    
    it "should route new_admin_path() to /admins/new" do
      new_admin_path().should == "/admins/new"
      formatted_new_admin_path(:format => 'xml').should == "/admins/new.xml"
      formatted_new_admin_path(:format => 'json').should == "/admins/new.json"
    end
    
    it "should route admin_(:id => '1') to /admins/1" do
      admin_path(:id => '1').should == "/admins/1"
      formatted_admin_path(:id => '1', :format => 'xml').should == "/admins/1.xml"
      formatted_admin_path(:id => '1', :format => 'json').should == "/admins/1.json"
    end
    
    it "should route edit_admin_path(:id => '1') to /admins/1/edit" do
      edit_admin_path(:id => '1').should == "/admins/1/edit"
    end
  end
  
end
