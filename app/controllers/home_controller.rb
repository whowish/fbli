class HomeController < ApplicationController
  
  def index
    
    params[:redirect_url] ||= "/home"
    
    if @member.is_guest and !Rails.env.development?
      render :login_required
      return
    end
    
    @zoom = 12
    
    if cookies[:latitude] and cookies[:longitude]
      params[:lat] ||= cookies[:latitude].to_f
      params[:lng] ||= cookies[:longitude].to_f
      
      # fail safe
      if params[:lat].to_f < 6 or params[:lat].to_f > 16
        params[:lat] = nil
      end
      
      if params[:lng].to_f < 95 or params[:lng].to_f > 107
        params[:lng] = nil
      end
      
    end
    
    @last_location = nil
    if params[:lat] and params[:lng]
      @last_location = [params[:lat], params[:lng]]
    end
    
  end
  
  def test
    
    params[:redirect_url] ||= "/home/test"
    
    @zoom = 12
    
    if cookies[:latitude] and cookies[:longitude]
      params[:lat] ||= cookies[:latitude].to_f
      params[:lng] ||= cookies[:longitude].to_f
      
      # fail safe
      if params[:lat].to_f < 6 or params[:lat].to_f > 16
        params[:lat] = nil
      end
      
      if params[:lng].to_f < 95 or params[:lng].to_f > 107
        params[:lng] = nil
      end
      
    end
    
    @last_location = nil
    if params[:lat] and params[:lng]
      @last_location = [params[:lat], params[:lng]]
    end
    
  end

end
