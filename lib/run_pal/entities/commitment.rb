module RunPal
  class Commitment < Entity
    attr_accessor :id, :user_id, :post_id, :amount, :fulfilled

    validates_presence_of :user_id, :post_id, :amount

    def initialize(attrs={})
      @fulfilled = false
      super
    end
  end
end
