module RunPal
  class JoinRequest < Entity
    attr_accessor :id, :user_id, :circle_id, :accepted

    def initialize(attrs={})
      @accepted = false
      super
    end
  end
end
