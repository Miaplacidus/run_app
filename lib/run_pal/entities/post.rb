module RunPal
  class Post < Entity
    attr_accessor :id, :creator_id, :time, :pace, :notes, :min_amt, :min_distance
    attr_accessor :age_pref, :gender_pref, :circle_id, :max_runners
    attr_accessor :address, :latitude, :longitude

    # when instantiated, commitment of creator automatically generated
    validates_presence_of :creator_id, :time, :pace, :min_amt, :address, :latitude, :longitude
    validates_presence_of :age_pref, :gender_pref, :max_runners, :min_distance

    def initialize(attrs={})
      @notes = ""
      @circle_id = nil
      super
    end
  end
end


=begin
PACE LEVELS
0 - All/Any levels
1 - Military: 6 min and under/mile
2 - Advanced: 6-7 min/mi
3 - High Intermediate: 7-8 min/mi
4 - Intermediate: 8-9 min/mi
5 - Beginner: 9-10 min/mi
6 - Jogger: 10-11 min/mi
7 - Speedwalker: 11-12 min/mi
8 - Sprints: 12+ min/mi

GENDER PREFERENCES
0 - BOTH
1 - FEMALE
2 - MALE
# Below only used for post sorting purposes
3 - BOTH USER GENDER AND GENDER NEUTRAL POSTS

AGE PREFERENCES
0 - No preference
1 - 18-22
2 - 23-29
3 - 30-39
4 - 40-49
5 - 50-59
6 - 60-69
7 - 70-79
8 - 80+
=end

