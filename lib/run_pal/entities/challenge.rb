module RunPal
  class Challenge < Entity
    attr_accessor :id, :name, :sender_id, :recipient_id, :post_id, :state, :notes
    validates_presence_of :name, :sender_id, :recipient_id

    # sender_id and recipient_id refer to the ids of the sending and
    # receiving circles, not to admins of said circles
    # A challenge can be in one of 3 states: pending, rejected, and accepted

    def initialize(attrs={})
      @state = 'pending'
      @notes = ''
      super
    end
  end
end
