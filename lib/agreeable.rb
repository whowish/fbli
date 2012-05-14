# encoding: utf-8
module Agreeable 
  
  # Assume that a model has :id, :agrees, and :disagrees
  # :id is the unique id that identifies the model
  # :agrees is the number of agrees
  # :disagees is the number of disagrees
  # 
  # When a post is agreed, its owner should gain a point.
  # Therefore, we assume that there is a class Member with the integer field :fame
  #
  # Here is how we organize the data
  # - A key "agreeable_key", which hold AGREE, DISAGREE, or nil in order to specify the action.
  # - A set "agree_set_key", which holds ids of which member agree to this post.
  # - A set "disagree_set_key", which holds ids of which member disagree to this post.
  #
  
  VOTE_UP = "UP"
  VOTE_DOWN = "DOWN"
  
  def self.included(base)
    base.class_eval do
      
      field :voted_up, :type => Integer, :default=>0
      field :voted_down, :type => Integer, :default=>0
      
    end
  end

  
  
  def member_vote(member, vote_type)
    #raise WhowishWord.word_for(:post, :login_required) if member.is_guest
    raise 'กรุณาล็อคอินก่อนที่จะโหวตค่ะ' if member.is_guest
    
    case vote_type
      when VOTE_UP
        return self.vote_up(member.id)
      when VOTE_DOWN
        return self.vote_down(member.id)
      else
        return self.cancel_vote(member.id)
    end
    
    
    
  end
  
  def vote_up(member_id)

    previous_value = $redis.getset(vote_key(member_id), VOTE_UP)
    
    action = false

    case previous_value
      when VOTE_UP
        # do nothing
      when VOTE_DOWN
        
        self.inc(:voted_up, 1)
        self.inc(:voted_down, -1)
        
        $redis.zadd(vote_up_set_key, -Time.now.to_f, member_id)
        $redis.zrem(vote_down_set_key, member_id)
        
        action = true
        
      else
        
        self.inc(:voted_up,1)
        
        $redis.zadd(vote_up_set_key, -Time.now.to_f, member_id)
        
        action = true
        
    end

    return action,previous_value
  end
  
  def vote_down(member_id)
    
    previous_value = $redis.getset(vote_key(member_id), VOTE_DOWN)
    
    action = false
    case previous_value
      
      when VOTE_UP
        
        self.inc(:voted_down,1)
        self.inc(:voted_up,-1)
        
        $redis.zadd(vote_down_set_key, -Time.now.to_f, member_id)
        $redis.zrem(vote_up_set_key, member_id)
        
        action = true
        
      when VOTE_DOWN
        # do nothing
      else
        
        self.inc(:voted_down,1)
        
        $redis.zadd(vote_down_set_key, -Time.now.to_f, member_id)
        
        action = true
        
      end
    
    return action,previous_value
  end
  
  def unagree(member_id)
    previous_value = $redis.getset(vote_key(member_id),"")
    
    
    action = false
    case previous_value
      when VOTE_UP
        
        self.inc(:voted_up,-1)
        
        $redis.zrem(vote_up_set_key, member_id)
        
        action = true
        
      when VOTE_DOWN
        
        self.inc(:voted_down,-1)
        
        $redis.zrem(vote_down_set_key, member_id)
        
        action = true
        
      else
        # do nothing
      end
    
    return action,previous_value
  end
  
  
  def is_vote_up_or_down(member_id)
    
    vote_type = $redis.get(vote_key(member_id))
    return (vote_type || "")
    
  end
  
  
  private
    def vote_key(member_id)
      "#{self.class.name}:#{self.id}:Member:#{member_id}"
    end
  
    def vote_up_set_key
      "#{self.class.name}:#{self.id}:#{VOTE_UP}"
    end
    
    def vote_down_set_key
      "#{self.class.name}:#{self.id}:#{VOTE_DOWN}"
    end
  
end