class Movie < ActiveRecord::Base
    
    def self.getRatings
        rating_records = select(:rating).distinct.order(:rating)
        ratings = []
        rating_records.each do |rating_record|
           ratings << rating_record.rating 
        end
        ratings
    end
end
