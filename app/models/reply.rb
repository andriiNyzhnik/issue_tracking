class Reply < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :repliable, polymorphic: true

  validates_presence_of :body

  after_create :notify_customer, if: proc { |reply| reply.repliable_type == 'Customer' }
  after_create :reset_ticket_status, if: proc { |reply| reply.repliable_type != 'Customer' }

  private

  def notify_customer
    UserMailer.ticket_updated(ticket).deliver_now
  end

  def reset_ticket_status
    ticket.update_attributes(status: Ticket::WAITING_FOR_STUFF_RESPONCE)
  end
end

# == Schema Information
#
# Table name: replies
#
#  id                            :integer          not null, primary key
#  body                          :text
#  repleable_id                  :integer
#  repleable_type                :string(255)
#  ticket_id                     :integer
#  created_at                    :datetime
#  updated_at                    :datetime
