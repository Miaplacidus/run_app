module RunPal
  class Circle < Entity
    attr_accessor :id, :name, :admin_id, :member_ids, :max_members, :latitude, :longitude, :description, :level, :city
    # member_ids: array -> CircleUsers table
    validates_presence_of :name, :admin_id, :max_members, :latitude, :longitude, :description, :level, :city

    def initialize(attrs={})
      @member_ids = [attrs[:admin_id]]
      super
    end
  end
end

=begin
  Circle level measured using same metric as pace
=end
