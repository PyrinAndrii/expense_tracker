Event = Struct.new(:name, :capacity) do
  def purchase_ticket_for(guest)
    tickets_sold << guest
  end

  def tickets_sold
    @tickets_sold ||= []
  end

  def inspect
    "#<Event #{name.inspect} (capacity: #{capacity})>"
  end
end

# Try to implement matcher class
=begin
class TicketsChecker
  include RSpec::Matchers::Composable
  TICKETS_QUANTITY = 10_000

  def matches?(event)
    @event = event
    @event.tickets_sold.empty?
  end

  def failure_message
    "expected #{@event} to have no tickets sold, but have sold #{@event.tickets_sold.count}"
  end
end

module EventOrganize
  def have_no_tickets_sold
    TicketsChecker.new.have_no_tickets_sold
  end

  def be_sold_out
    TicketsChecker.new
  end
end

RSpec.configure do |config|
  config.include EventOrganize
end

=end

RSpec::Matchers.define :have_no_tickets_sold do
  match { |event| event.tickets_sold.empty? }
  failure_message { |event| super() + failure_reasone(event) }

  def failure_reasone(event)
    ", but have sold #{event.tickets_sold.count}"
  end
end

RSpec::Matchers.define :be_sold_out do
  TICKETS_QUANTITY = 10_000
  match { |event| event.tickets_sold.count == TICKETS_QUANTITY }
  failure_message { |event| super() + failure_reasone(event) }

  def failure_reasone(event)
    ", but have sold only #{event.tickets_sold.count}"
  end
end

RSpec.describe '`have_no_tickets_sold` matcher' do
  let(:art_show) { Event.new('Art Show', 100) }

  example 'passing expectation' do
    expect(art_show).to have_no_tickets_sold
  end

  example 'failing expectation' do
    art_show.purchase_ticket_for(:a_friend)

    expect(art_show).to have_no_tickets_sold # have not to pass
  end

  example 'passing `have not` expectation' do
    art_show.purchase_ticket_for(:a_friend)

    expect(art_show).not_to have_no_tickets_sold
  end
end

RSpec.describe '`be_sold_out` matcher' do
  let(:u2_concert) { Event.new('U2 Concert', 10_000) }

  example 'passing expectation' do
    10_000.times { u2_concert.purchase_ticket_for(:a_fan) }

    expect(u2_concert).to be_sold_out
  end

  example 'failing expectation' do
    9_900.times { u2_concert.purchase_ticket_for(:a_fan) }

    expect(u2_concert).to be_sold_out # have not to pass
  end
end
