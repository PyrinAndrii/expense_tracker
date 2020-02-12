# PublicCompany = Struct.new(:name, :value_per_share, :share_count) do
#   def got_better_than_expected_revenues
#     self.value_per_share *= rand(1.05..1.10)
#   end
#
#   def market_cap
#     @market_cap ||= value_per_share * share_count
#   end
# end
#
# RSpec.describe PublicCompany do
#   let(:company) { PublicCompany.new('Nile', 10, 100_000) }
#
#   it 'increases its market cap when it gets better than expected revenues' do
#     p before_market_cap = company.market_cap
#     p before_market_cap
#     company.got_better_than_expected_revenues
#     p after_market_cap = company.market_cap
#
#     expect(after_market_cap).to be >  before_market_cap
#   end
# end
# class Water
#   def self.elements
#     [:oxygen, :hydrogen]
#   end
# end
#
# RSpec.describe Water do
#   it 'is H2O' do
#     expect(Water.elements.sort).to contain_exactly :hydrogen, :hydrogen, :oxygen
#   end
# end
require 'date'
Calendar = Struct.new(:date_string) do
  def on_weekend?
    Date.parse(date_string).saturday?
  end
end

RSpec.describe Calendar do
let(:sunday_date) { Calendar.new('Sun, 11 Jun 2017') }
  it 'considers sundays to be on the weekend' do
    expect(sunday_date).to be_on_weekend
  end
end
