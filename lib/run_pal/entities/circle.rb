module RunPal
  class Circle < Entity
    attr_accessor :id, :name, :admin_id, :member_ids, :max_members, :latitude, :longitude, :description, :level
    # member_ids: array -> CircleUsers table
    validates_presence_of :name, :admin_id, :max_members, :latitude, :longitude, :description, :level

    def initialize(attrs={})
      @member_ids = [attrs[:admin_id]]
      super
    end
  end
end

=begin
  Circle level measured using same metric as pace, with added
  level of -1 meaning any/all levels of posts may be posted
  by this circle.
=end
