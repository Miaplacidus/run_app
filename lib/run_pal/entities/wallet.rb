module RunPal
  class Wallet < Entity
    attr_accessor :id, :user_id, :balance

    def initialize(attrs={})
      @balance = 0
      super
    end
  end
end
