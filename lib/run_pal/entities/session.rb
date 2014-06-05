module RunPal
  class Session < Entity
    attr_reader :id, :session_key, :user_id

    def initialize(attrs)
      @key = attrs[:key]
      @user_id = attrs[:user_id]
      super
    end
  end
end
