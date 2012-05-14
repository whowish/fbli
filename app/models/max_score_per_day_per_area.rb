class MaxScorePerDayPerArea
  include Mongoid::Document
  
  field :member_id, :type => String
  field :contribute_date, :type => Date, :default => lambda { Date.parse(Time.now.strftime('%Y-%m-%d')) }
  field :location_group, :type => Array
  field :score, :type => Integer, :default=>0

  index [
          [:location_group, Mongo::GEO2D ],
          [:contribute_date,Mongo::DESCENDING ],
          [:score, Mongo::DESCENDING]
        ]
  
  index [
          [:location_group, Mongo::GEO2D ],
          [:contribute_date, Mongo::DESCENDING]
        ], :unique=>true

  index [
          [:contribute_date,Mongo::DESCENDING ]
        ]

  def self.get(location, date)

    if date.instance_of?(Time)
      date = Date.parse(date.in_time_zone.strftime('%Y-%m-%d'))
    end

    return self.first(:conditions=>{:location_group => location,
                                    :contribute_date => date
                                    })

  end

  def self.update_max(scorePerDay)

    count_round = 0
    
    while count_round < 100
    
      max = self.get(scorePerDay.location_group, scorePerDay.contribute_date)

      if !max
        
        max = self.create(:location_group => scorePerDay.location_group,
                          :contribute_date => scorePerDay.contribute_date,
                          :member_id => scorePerDay.member_id,
                          :score => scorePerDay.score)
                          
        last_error = Mongoid.database.command({:getlasterror => 1})
        
        if last_error['code'].to_i == 11000
          max = self.get(scorePerDay.location_group, scorePerDay.contribute_date)
        end
        
      end

      maxScorePerDay = ScorePerDay.where(:location_group=>scorePerDay.location_group).where(:contribute_date => scorePerDay.contribute_date).desc(:score).limit(1).entries.first

      MaxScorePerDayPerArea.collection.update( { "_id"=>max.id, 
                                                  "score"=>max.score}, 
                                                { "$set" => {"member_id" => maxScorePerDay.member_id, 
                                                              "score" => maxScorePerDay.score
                                                            }
                                                })
                                                  
      last_error = Mongoid.database.command({:getlasterror => 1})
      Rails.logger.error { "#{last_error.inspect}"}

      break if last_error['n'].to_i != 0

      count_round = count_round + 1
    end
    
    Rails.logger.error { "MaxScorePerDayPerArea's num loop = #{count_round}"}

  end
  
  
end