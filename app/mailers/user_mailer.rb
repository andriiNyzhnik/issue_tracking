class UserMailer < ActionMailer::Base
  default from: 'notify@issue_tracking.com'

  def ticket_created(ticket)
    @ticket = ticket
    mail(to: ticket.customer.email, subject: 'New ticket has been created')
  end

  def ticket_assigned(ticket)
    @ticket = ticket
    mail(to: ticket.customer.email, subject: 'Ticket has been assigned')
  end

  def ticket_updated(ticket)
    @ticket = ticket
    mail(to: ticket.customer.email, subject: 'Ticket has been updated.')
  end
end
