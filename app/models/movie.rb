class Movie < ActiveRecord::Base

  def self.getAllRatings
    return ['G','PG','PG-13','R']
  end

end
