module RunPal
  class JoinRequest < Entity
    attr_accessor :user_id, :circle_id, :accepted

    def initialize(attrs={})
      @accepted = false
    end
  end
end
