class ScorePerDay
  include Mongoid::Document

  SIZE = 0.02

  field :member_id, :type => String
  field :contribute_date, :type => Date, :default => lambda { Date.parse(Time.now.in_time_zone.strftime('%Y-%m-%d')) }
  field :location_group, :type => Array
  field :score, :type => Integer, :default=>0

  index [
          [:location_group, Mongo::GEO2D ],
          [:contribute_date,Mongo::DESCENDING ],
          [:score, Mongo::DESCENDING]
        ]
  
  index [
          [:location_group, Mongo::GEO2D ],
          [:member_id,Mongo::DESCENDING ],
          [:contribute_date, Mongo::DESCENDING]
        ], :unique=>true
        
  index [
          [ :location_group, Mongo::GEO2D ],
          [:contribute_date,Mongo::DESCENDING ]
        ]
        
   index [
          [:contribute_date,Mongo::DESCENDING ]
        ]
        
  def self.get(member_id, date, location_group)
    
    if date.instance_of?(Time)
      date = Date.parse(date.in_time_zone.strftime('%Y-%m-%d'))
    end
    
    return ScorePerDay.first(:conditions=>{
                                            :member_id => member_id,
                                            :contribute_date => date,
                                            :location_group => location_group
                                            })
  end

  def self.update_member(member_id, diff_score, location, date=Date.parse(Time.now.in_time_zone.strftime('%Y-%m-%d')))
    
    if date.instance_of?(Time)
      date = Date.parse(date.in_time_zone.strftime('%Y-%m-%d'))
    end
    
    location_group = self.get_location_group(location)
    
    scorePerDay = self.get(member_id, date, location_group)
    
    if !scorePerDay
      scorePerDay = ScorePerDay.create(:member_id => member_id,
                                        :contribute_date => date,
                                        :location_group => location_group)
      last_error = Mongoid.database.command({:getlasterror => 1})
      
      if last_error['code'].to_i == 11000
        scorePerDay = self.get(member_id, date, location_group)
      end
      
    end
    
    scorePerDay.inc(:score, diff_score)
    
    MaxScorePerDayPerArea.update_max(scorePerDay)
    
  end
  
 
  
  def self.get_location_group(location)
    location_group = []
    location_group[0] = SanitizerLocation.sanitize(SIZE, location[0])
    location_group[1] = SanitizerLocation.sanitize(SIZE, location[1])
    return location_group
  end
 
end