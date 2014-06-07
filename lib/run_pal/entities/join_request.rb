module RunPal
  class JoinRequest < Entity
    attr_accessor :user_id, :circle_id, :accepted

    def initialize
      @accepted = false
    end
  end
end
