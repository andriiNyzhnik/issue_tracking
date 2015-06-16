class TicketsController < ApplicationController
  respond_to :html

  def show
    @ticket = Ticket.find_by_slug(params[:slug])
    @ticket.replies.build
    respond_with @ticket
  end

  def new
    @ticket = Ticket.new
    @ticket.customer = Customer.new
    respond_with(@ticket)
  end

  def create
    @ticket = Ticket.new(ticket_params)
    flash[:notice] = 'Ticket has been successfully created' if @ticket.save
    respond_with @ticket, location: root_path
  end

  def update
    @ticket = Ticket.find(params[:slug])
    flash[:notice] = 'Ticket has been successfully updated' if @ticket.update(ticket_params)
    respond_with @ticket, location: ticket_path(@ticket.slug)
  end

  private

  def ticket_params
    params.require(:ticket).permit(:subject,
                                   :department,
                                   :content,
                                   customer_attributes: [:name, :email],
                                   replies_attributes: [:id, :body, :repliable_id, :repliable_type])
  end
end
