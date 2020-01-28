module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)
  ExpenseRecords = Struct.new(:params)

  class Ledger
    def record(expense)
    end

    def expenses_on(date)
    end
  end
end
