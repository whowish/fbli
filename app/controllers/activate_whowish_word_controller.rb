class ActivateWhowishWordController < ApplicationController
  
  def index
    
    if @member.is_admin
      if params[:activate] == "yes"
        session[:whowish_word] = "yes"
      else
        session[:whowish_word] = "no"
      end
    end
    
    redirect_to "/"
  end
  
end
