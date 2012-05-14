class LogoutController < ApplicationController
  
  def index
    Member.clear_cookies(session,cookies);
    
    redirect_to "/"
  end
  
end
