require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper
include AuthenticatedSystem

describe SessionsController do
  fixtures :admins
  
  before do
    # FIXME -- sessions controller not testing xml logins 
    stub!(:authenticate_with_http_basic).and_return nil
  end    
  describe "logout_killing_session!" do
    before do
      login_as :quentin
      stub!(:reset_session)
    end
    it 'resets the session'         do should_receive(:reset_session);         logout_killing_session! end
    it 'kills my auth_token cookie' do should_receive(:kill_remember_cookie!); logout_killing_session! end
    it 'nils the current admin'      do logout_killing_session!; current_admin.should be_nil end
    it 'kills :admin_id session' do
      session.stub!(:[]=)
      session.should_receive(:[]=).with(:admin_id, nil).at_least(:once)
      logout_killing_session!
    end
    it 'forgets me' do    
      current_admin.remember_me
      current_admin.remember_token.should_not be_nil; current_admin.remember_token_expires_at.should_not be_nil
      Admin.find(1).remember_token.should_not be_nil; Admin.find(1).remember_token_expires_at.should_not be_nil
      logout_killing_session!
      Admin.find(1).remember_token.should     be_nil; Admin.find(1).remember_token_expires_at.should     be_nil
    end
  end

  describe "logout_keeping_session!" do
    before do
      login_as :quentin
      stub!(:reset_session)
    end
    it 'does not reset the session' do should_not_receive(:reset_session);   logout_keeping_session! end
    it 'kills my auth_token cookie' do should_receive(:kill_remember_cookie!); logout_keeping_session! end
    it 'nils the current admin'      do logout_keeping_session!; current_admin.should be_nil end
    it 'kills :admin_id session' do
      session.stub!(:[]=)
      session.should_receive(:[]=).with(:admin_id, nil).at_least(:once)
      logout_keeping_session!
    end
    it 'forgets me' do    
      current_admin.remember_me
      current_admin.remember_token.should_not be_nil; current_admin.remember_token_expires_at.should_not be_nil
      Admin.find(1).remember_token.should_not be_nil; Admin.find(1).remember_token_expires_at.should_not be_nil
      logout_keeping_session!
      Admin.find(1).remember_token.should     be_nil; Admin.find(1).remember_token_expires_at.should     be_nil
    end
  end
  
  describe 'When logged out' do 
    it "should not be authorized?" do
      authorized?().should be_false
    end    
  end

  #
  # Cookie Login
  #
  describe "Logging in by cookie" do
    def set_remember_token token, time
      @admin[:remember_token]            = token; 
      @admin[:remember_token_expires_at] = time
      @admin.save!
    end    
    before do 
      @admin = Admin.find(:first); 
      set_remember_token 'hello!', 5.minutes.from_now
    end    
    it 'logs in with cookie' do
      stub!(:cookies).and_return({ :auth_token => 'hello!' })
      logged_in?.should be_true
    end
    
    it 'fails cookie login with bad cookie' do
      should_receive(:cookies).at_least(:once).and_return({ :auth_token => 'i_haxxor_joo' })
      logged_in?.should_not be_true
    end
    
    it 'fails cookie login with no cookie' do
      set_remember_token nil, nil
      should_receive(:cookies).at_least(:once).and_return({ })
      logged_in?.should_not be_true
    end
    
    it 'fails expired cookie login' do
      set_remember_token 'hello!', 5.minutes.ago
      stub!(:cookies).and_return({ :auth_token => 'hello!' })
      logged_in?.should_not be_true
    end
  end
  
end
