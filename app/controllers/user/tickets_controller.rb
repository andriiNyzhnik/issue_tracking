class User::TicketsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html

  def edit
    @ticket = Ticket.find(params[:id])
    @ticket.replies.build
    respond_with @ticket
  end

  def unassigned
    @tickets = Ticket.includes(:customer).unassigned
    respond_with @tickets
  end

  def open
    @tickets = Ticket.by_owner(current_user)
               .by_status([Ticket::WAITING_FOR_STUFF_RESPONCE,
                           Ticket::WAITING_FOR_CUSTOMER])
    respond_with @tickets
  end

  def hold
    @tickets = Ticket.by_owner(current_user).by_status(Ticket::HOLD)
    respond_with @tickets
  end

  def closed
    @tickets = Ticket.by_owner(current_user)
               .by_status([Ticket::CANCELLED, Ticket::COMPLETED])
    respond_with @tickets
  end

  def assign
    ticket = Ticket.find(params[:id])
    if ticket.update_attributes(owner_id: current_user.id,
                                status: Ticket::WAITING_FOR_CUSTOMER)
      flash[:notice] = 'Ticket has been successlully assigned'
      UserMailer.ticket_assigned(ticket).deliver_now
    else
      flash[:alert] = ticket.errors.full_messages.to_sentence
    end
    respond_with ticket, location: edit_user_ticket_path(ticket)
  end

  def update
    @ticket = Ticket.find(params[:id])
    flash[:notice] = 'Ticket has been successfully updated' if @ticket.update(ticket_params)
    respond_with @ticket, location: edit_user_ticket_path(@ticket)
  end

  def search
    @tickets = Ticket.search(params[:q])
    if @tickets.size == 1
      redirect_to edit_user_ticket_path(@tickets.first)
      return
    end
    respond_with @tickets
  end

  private

  def ticket_params
    params.require(:ticket).permit(:owner_id,
                                   :status,
                                   replies_attributes: [:id, :body, :repliable_id, :repliable_type])
  end
end
