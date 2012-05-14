# encoding: utf-8
class PostController < ApplicationController

  TIME_LIMIT = 360 * 6 * 3600
  DEPRECATED_TIME_LIMIT = 2 * 86400
  
  def index
    
    params[:limit] ||= 100
    params[:limit] = params[:limit].to_i
    
    
    params[:limit] = 100 if params[:limit] > 100
    
    params[:critical] ||= false
    params[:critical] = (params[:critical]=="yes")
    
    left_top_x = [ params[:ne_lat].to_f, params[:sw_lat].to_f].min
    right_bottom_x = [ params[:ne_lat].to_f, params[:sw_lat].to_f].max
    
    left_top_y = [ params[:ne_lng].to_f, params[:sw_lng].to_f].min
    right_bottom_y = [ params[:ne_lng].to_f, params[:sw_lng].to_f].max
    
    box = [ [left_top_x, left_top_y], 
            [right_bottom_x, right_bottom_y]]

    groups = []
    
    cut_time = Time.now.utc - TIME_LIMIT
    
  
    
    half_width = (right_bottom_x - left_top_x) * 0.2
    half_height = (right_bottom_y - left_top_y) * 0.2
    
    smallBox = [  [left_top_x + half_width/2.0, left_top_y + half_height/2.0], 
                    [right_bottom_x - half_width/2.0, right_bottom_y - half_height/2.0]]
    
    params[:q_from] ||= cut_time 
    params[:q_to] ||= Time.now
    
    params[:q_from] = cut_time if params[:q_from] == ""
    params[:q_to] = Time.now if params[:q_to] == ""
    
    q_from = Time.parse(params[:q_from].to_s + " 00:00:00").utc
    q_to = Time.parse(params[:q_to].to_s + " 23:59:59").utc
                    
    if params[:filter] == ""
                    
      groups = PostGroup.where(:time => {'$gte' => q_from, '$lt' => q_to}).where(:location.within => { "$box" => smallBox }).desc(:time).limit(params[:limit]).entries
    
      if groups.length < params[:limit]
        groups += PostGroup.where(:location.within => { "$box" => smallBox }).where(:time.lt => cut_time).desc(:time).limit(params[:limit] - groups.length).entries
      end
    
    elsif params[:filter] == "dengue"
      groups = PostGroup.where(:time => {'$gte' => q_from, '$lt' => q_to}).where(:location.within => { "$box" => smallBox }).where(:disease_type.in => Post::DENGUE_TYPE).desc(:time).limit(params[:limit]).entries
    
      if groups.length < params[:limit]
        groups += PostGroup.where(:location.within => { "$box" => smallBox }).where(:time.lt => cut_time).where(:disease_type.in => Post::DENGUE_TYPE).desc(:time).limit(params[:limit] - groups.length).entries
        end
 
      else
        groups = PostGroup.where(:time => {'$gte' => q_from, '$lt' => q_to}).where(:location.within => { "$box" => smallBox }).where(:disease_type=>params[:filter].upcase).desc(:time).limit(params[:limit]).entries
    
      if groups.length < params[:limit]
        groups += PostGroup.where(:location.within => { "$box" => smallBox }).where(:time.lt => cut_time).where(:disease_type=>params[:filter].upcase).desc(:time).limit(params[:limit] - groups.length).entries
      end
    end
      

  
    
    results = []

    groups.each { |group|
    
      age = "new"
#      age = "new" if (Time.now.utc - group.time.utc) < TIME_LIMIT
#      age = "old" if (Time.now.utc - group.time.utc) > DEPRECATED_TIME_LIMIT
    
      results.push({
                    :location=>group.location,
                    :id=>group.id,
                    :disease_type => group.disease_type,
                    :age => age,
                    :is_flagged => (group.score <= -2)
                   })
    }

    render :json=>{:ok=>true, :results=>results}
    
    @last_location = [(left_top_x + right_bottom_x)/2, (left_top_y + right_bottom_y)/2]
    
  rescue LogicException=>e
    render :json=>{:ok=>false, :error_messages=>e.message}
  end
  
  
  def view
  
    @group = PostGroup.get_from_params(params)
    raise "Cannot find any group here" if !@group
    @group.inc(:views, 1)
    
    @etag = [Rails.application.class.parent_name, "View", @group.id, @group.updated_ticket_number, ((request.xhr?)?"xhr":"normal"), @member.id, @locale].join("_")
    
    @cache_testing = nil
    
    if request.env["HTTP_IF_NONE_MATCH"] == @etag
      @cache_testing = "match"
      Rails.logger.info { "match" }
      headers["X-Cache"] = "HTTP"
      head :not_modified
      return
    end

    response.headers["ETag"] = @etag
    
    @cache_key = [Rails.application.class.parent_name, "View", @group.id, @group.updated_ticket_number].join("_")
    

    params[:limit] = 5

    if data = Rails.cache.read(@cache_key)
      
      @cache_testing = "hit"
      Rails.logger.info { "hit" }
      headers["X-Cache"] = "HIT"
      
      Post.class # fake reference for Marshal.load
      @posts = Marshal.load(data)
      
    else
      
      @cache_testing = "miss"
      Rails.logger.info { "miss" }
      headers["X-Cache"] = "MISS"
      
      @posts = Post.where(:post_group_id => @group.id).desc(:time).limit(params[:limit]).entries
    
      if @posts.length == 0
        @group.destroy 
        raise 'No data within this group'
      end
    
      Rails.cache.write(@cache_key, Marshal.dump(@posts))

    end

    @marker_pipe = []
    @posts.each_with_index { |post,index|

      marker = []

      marker.push("color:red")

      marker.push("#{post.location[0]},#{post.location[1]}")

      @marker_pipe.push(marker.join("|"))
    }

    @marker_pipe = @marker_pipe.map { |m| "markers=#{CGI.escape(m)}"}.join("&")


    @view_url_without_domain = "/post/view/id/#{@group.id}/#{@group.updated_ticket_number}"
    @view_url = "http://#{DOMAIN_NAME}#{@view_url_without_domain}"
    @center = @group.center
    @google_map_image_url = "http://maps.googleapis.com/maps/api/staticmap?#{@marker_pipe}&sensor=false&center=#{@center.join(',')}&size=270x270&zoom=15&language=#{@locale}"

    @post_text = nil
    @image_url = nil
    @share_title = nil

    if @posts[0]

      @post_text = ""

      @share_title = "#{@posts[0].place} #{@post_text}"

      @image_url = @google_map_image_url
      @image_url = @posts[0].get_image if @posts[0].has_image?

    end


  rescue LogicException=>e
    Rails.logger.info { e }
    Rails.logger.info { e.backtrace.join("\n") }
    render :view_error
  end


  def create_form

    params[:lat] = params[:lat].to_f.round(4)
    params[:lng] = params[:lng].to_f.round(4)
    
    params[:redirect_url] ||= "/post/create_form/#{params[:lat]}/#{params[:lng]}"
    
    if @member.is_guest
      render :template => 'home/login_required'
      return
    end
    
    @marker_pipe = ["color:red", "label:P", "#{params[:lat]},#{params[:lng]}"]
    
  end
  
  
  def create
   
    raise WhowishWord.word_for(:post, :login_required) if @member.is_guest
    
    begin
      admit_time = Date.parse(params[:admit_time])
    rescue
      render :json=>{:ok=>false,:error_messages=>"invalid admit date"}
      return
    end
    
    begin
      patient_birthday = Date.parse(params[:patient_birthday])
    rescue
      render :json=>{:ok=>false,:error_messages=>"invalid patient birthday"}
      return
    end

    post = Post.create(:location=> [params[:lat].to_f, params[:lng].to_f],
                        :image => params[:image],
                        :message => params[:message],
                        :place => params[:place],
                        :address => params[:address],
                        :member_id => @member.id,
                        :name => @member.name,
                        :disease_type => params[:disease_type],
                        :occupation => params[:occupation],
                        :gender => params[:gender],
                        :admit_time => admit_time,
                        :patient_birthday =>patient_birthday
                        )
    
    render :json=>{:ok=>true}
    
  rescue LogicException => e
    render :json=>{:ok=>false,:error_messages=>e.message}
  end


  def vote

    @post = Post.find(params[:id])
    
    raise 'ข่าวนี้เก่าเกิน 3 ชั่วโมงแล้วค่ะ จึงไม่สามารถโหวตขึ้น/ลง ได้' if !@post.votable?

    @post.member_vote(@member, params[:vote])
    
    if (@post.voted_up - @post.voted_down) <= -5
      FlaggedPost.move(@post)
    end
    
    if request.xhr?
      render :json=>{:ok=>true}
    else
      redirect_to "/post/view/id/#{@post.post_group_id}"
    end
  rescue LogicException => e
    if request.xhr?
      render :json=>{:ok=>false,:error_messages=>e.message}
    else
      redirect_to "/post/view/id/#{@post.post_group_id}"
    end

  end


  def delete
    
    post = Post.find(params[:id])
    raise "You are not allowed to modify this post." if !post.is_modification_allowed(@member)
    
    post.destroy
    render :json=>{:ok=>true}
    
  rescue LogicException => e
    render :json=>{:ok=>false,:error_messages=>e.message} 
  end


  def edit_form
    
    @post = Post.find(params[:id])
    @marker_pipe = CGI.escape("color:red|label:P|#{@post.location.join(",")}")
    
  end
  
  
  def edit
    
    @post = Post.find(params[:id])
    
    raise "You are not allowed to modify this post." if !@post.is_modification_allowed(@member)
    
    begin
      admit_time = Date.parse(params[:admit_time])
    rescue
      render :json=>{:ok=>false,:error_messages=>"invalid admit date"}
      return
    end
    
    begin
      patient_birthday = Date.parse(params[:patient_birthday])
    rescue
      render :json=>{:ok=>false,:error_messages=>"invalid patient birthday"}
      return
    end
    
    @post.update_attributes(:place=>params[:place], 
                            :address=>params[:address],
                            :disease_type => params[:disease_type],
                            :occupation => params[:occupation],
                            :gender => params[:gender],
                            :admit_time => admit_time,
                            :patient_birthday => patient_birthday,                            
                            :message=>params[:message])   
                            
    render :json=>{:ok=>true}
  rescue LogicException => e
    render :json=>{:ok=>false,:error_messages=>e.message}     
  end

end
