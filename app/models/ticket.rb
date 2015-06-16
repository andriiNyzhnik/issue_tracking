class Ticket < ActiveRecord::Base
  WAITING_FOR_STUFF_RESPONCE = 'waiting_for_stuff_responce'
  WAITING_FOR_CUSTOMER = 'waiting_for_customer'
  HOLD = 'hold'
  CANCELLED = 'cancelled'
  COMPLETED = 'completed'
  STATUSES = [WAITING_FOR_STUFF_RESPONCE, WAITING_FOR_CUSTOMER, HOLD, CANCELLED, COMPLETED]

  belongs_to :customer
  belongs_to :owner, class_name: 'User'
  has_many :replies

  validates_presence_of :subject, :department, :content, :customer
  validates :status, inclusion: { in: STATUSES }

  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :replies

  before_validation :set_status, on: :create
  before_create :ensure_slug
  after_create :send_to_customer

  scope :unassigned, -> { where(owner_id: nil) }
  scope :by_owner, ->(owner) { where(owner_id: owner.id) }
  scope :by_status, ->(status) { where(status: status) }

  def build_customer(customer)
    self.customer = Customer.find_or_create_by(customer)
  end

  def self.search(qeury)
    sql = <<-SQL
      select tickets.* from tickets
        where slug = "#{qeury}"
          OR subject = "#{qeury}"
          OR content LIKE "%#{qeury}%"
    SQL
    find_by_sql(sql)
  end

  private

  def random_chars
    Array.new(3) { [*'A'..'Z'].sample }.join
  end

  def random_hex
    Array.new(2) { rand(16).to_s(16).upcase }.join
  end

  def generate_slug
    [random_chars, random_hex, random_chars, random_hex, random_chars].join('-')
  end

  def ensure_slug
    loop do
      slug = generate_slug
      unless Ticket.find_by_slug(slug)
        self.slug = slug
        break
      end
    end
  end

  def send_to_customer
    UserMailer.ticket_created(self).deliver_now
  end

  def set_status
    self.status = WAITING_FOR_STUFF_RESPONCE
  end
end

# == Schema Information
#
# Table name: tickets
#
#  id                            :integer          not null, primary key
#  department                    :string(255)
#  subject                       :string(255)
#  content                       :text
#  created_at                    :datetime
#  updated_at                    :datetime
#  customer_id                   :integer
#  slug                          :string(255)
#  status                        :string(255)
#  owner_id                      :integer
