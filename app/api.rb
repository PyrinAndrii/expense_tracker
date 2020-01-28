require_relative 'ledger'
require 'sinatra/base'
require 'json'
require 'pry'

module ExpenseTracker
  class API < Sinatra::Base
    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super() # rest of initialization from Sinatra
    end

    post '/expenses' do
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)

      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end

    get '/expenses/:date' do
      date = params['date']
      result = @ledger.expenses_on(date)

      if result.any?
        JSON.generate(result.params)
      else
        JSON.generate([])
      end
    end
  end
end
