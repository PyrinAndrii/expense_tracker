require_relative '../../../app/api'
require 'rack/test'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  RSpec.describe API do
    include Rack::Test::Methods

    def app
      API.new(ledger: ledger)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }
    let(:parsed) { JSON.parse(last_response.body) }
    let(:expense) { { 'some' => 'data' } }

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do
        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)
          p parsed.class
          expect(parsed).to include('expense_id' => 417)
        end

        it 'respond with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)

          expect(last_response.status).to eq(200)
        end
      end

      context 'when the expense fails validation' do
        before do
          allow(ledger).to receive(:record)
            .with(expense)
            .and_return(RecordResult.new(false, 417, 'Expense incomplete'))
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)

          expect(parsed).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET /expenses/:date' do

      context 'when expenses exist on the given date' do
        let(:date) { '2017-06-12' }
        let(:expense_records) do
          [
            {
              'payee' => 'Whole Foods',
              'amount' => 95.20,
              'date' => date,
              'id' => 1
            }
          ]
        end

        before do
          allow(ledger).to receive(:expenses_on)
          .with(date)
          .and_return(ExpenseRecords.new(expense_records))
        end

        it 'returns the expense records as JSON' do
          get '/expenses/2017-06-12'

          expect(parsed.first).to include('payee' => 'Whole Foods')
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2017-06-12'

          expect(last_response.status).to eq(200)
        end
      end

      context 'when there are no expenses on the given date' do
        let(:date) { '2030-06-12' }

        before do
          allow(ledger).to receive(:expenses_on)
          .with(date)
          .and_return(ExpenseRecords.new([]))
        end

        it 'returns an empty array as JSON' do
          get '/expenses/2030-06-12'

          expect(parsed).to eq([])
        end

        it 'responds with a 200 (OK)' do
          get '/expenses/2030-06-12'

          expect(last_response.status).to eq(200)
        end
      end
    end
  end
end
