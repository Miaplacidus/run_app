module RunPal
  class Session < Entity
    attr_reader :id, :session_key, :user_id

    def initialize(attrs={})
      @session_key = attrs[:session_key]
      @user_id = attrs[:user_id]
      super
    end
  end
end
