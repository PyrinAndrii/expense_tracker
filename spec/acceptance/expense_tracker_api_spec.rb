require_relative '../../app/api'
require 'rack/test'
require 'json'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end

    def post_expense(expense)
      post '/expenses', JSON.generate(expense)
      expect(last_response.status).to eq(200)

      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => parsed['expanse_id'])
    end

    it 'records submitted expenses' do
      pending 'Need to persist expenses'
      coffee = post_expense(
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2020-01-01'
      )

      zoo = post_expense(
        'payee' => 'Zoo',
        'amount' => 15.25,
        'date' => '2017-06-10'
      )

      groceries = post_expense(
        'payee' => 'Whole Foods',
        'amount' => 95.20,
        'date' => '2017-06-11'
      )

      get '/expenses/2017-06-10'
      expect(last_response.status).to eq(200)
      expenses = JSON.parse(last_response.body)
      expect(expenses).to contain_exactly(coffee, zoo)
    end
  end
end

#
# #<Sinatra::Request:0x00007f931a158858 @params={}, @env={"rack.version"=>[1, 3], "rack.input"=>#<StringIO:0x00007f931a159028>, "rack.errors"=>#<StringIO:0x00007f931a1590a0>, "rack.multithread"=>true, "rack.multiprocess"=>true, "rack.run_once"=>false, "REQUEST_METHOD"=>"GET", "SERVER_NAME
# "=>"example.org", "SERVER_PORT"=>"80", "QUERY_STRING"=>"", "PATH_INFO"=>"/expenses/2017-06-12", "rack.url_scheme"=>"http", "HTTPS"=>"off", "SCRIPT_NAME"=>"", "CONTENT_LENGTH"=>"0", "rack.test"=>true, "REMOTE_ADDR"=>"127.0.0.1", "HTTP_HOST"=>"example.org", "HTTP_COOKIE"=>"", "rack.logger
# "=>#<Rack::NullLogger:0x00007f931a15a270 @app=#<Rack::Protection::FrameOptions:0x00007f931a15a338 @app=#<Rack::Protection::HttpOrigin:0x00007f931a15a428 @app=#<Rack::Protection::IPSpoofing:0x00007f931a15a4a0 @app=#<Rack::Protection::JsonCsrf:0x00007f931a15a540 @app=#<Rack::Protection::P
# athTraversal:0x00007f931a15a5b8 @app=#<Rack::Protection::XSSHeader:0x00007f931a15a658 @app=#<ExpenseTracker::API:0x00007f931a15b238 @ledger=#<InstanceDouble(ExpenseTracker::Ledger) (anonymous)>, @default_layout=:layout, @preferred_extension=nil, @app=nil, @template_cache=#<Tilt::Cache:0
# x00007f931a15b1e8 @cache={}>>, @options={:reaction=>:drop_session, :logging=>true, :message=>"Forbidden", :encryptor=>Digest::SHA1, :session_key=>"rack.session", :status=>403, :allow_empty_referrer=>true, :report_key=>"protection.failed", :html_types=>["text/html", "application/xhtml",
# "text/xml", "application/xml"], :xss_mode=>:block, :nosniff=>true, :img_src=>"'self' data:", :font_src=>"'self'", :without_session=>true}>, @options={:reaction=>:drop_session, :logging=>true, :message=>"Forbidden", :encryptor=>Digest::SHA1, :session_key=>"rack.session", :status=>403, :a
# llow_empty_referrer=>true, :report_key=>"protection.failed", :html_types=>["text/html", "application/xhtml", "text/xml", "application/xml"], :img_src=>"'self' data:", :font_src=>"'self'", :without_session=>true}>, @options={:reaction=>:drop_session, :logging=>true, :message=>"Forbidden"
# , :encryptor=>Digest::SHA1, :session_key=>"rack.session", :status=>403, :allow_empty_referrer=>true, :report_key=>"protection.failed", :html_types=>["text/html", "application/xhtml", "text/xml", "application/xml"], :allow_if=>nil, :img_src=>"'self' data:", :font_src=>"'self'", :without_
# session=>true}>, @options={:reaction=>:drop_session, :logging=>true, :message=>"Forbidden", :encryptor=>Digest::SHA1, :session_key=>"rack.session", :status=>403, :allow_empty_referrer=>true, :report_key=>"protection.failed", :html_types=>["text/html", "application/xhtml", "text/xml", "a
# pplication/xml"], :img_src=>"'self' data:", :font_src=>"'self'", :without_session=>true}>, @options={:reaction=>:drop_session, :logging=>true, :message=>"Forbidden", :encryptor=>Digest::SHA1, :session_key=>"rack.session", :status=>403, :allow_empty_referrer=>true, :report_key=>"protecti
# on.failed", :html_types=>["text/html", "application/xhtml", "text/xml", "application/xml"], :allow_if=>nil, :img_src=>"'self' data:", :font_src=>"'self'", :without_session=>true}>, @options={:reaction=>:drop_session, :logging=>true, :message=>"Forbidden", :encryptor=>Digest::SHA1, :sess
# ion_key=>"rack.session", :status=>403, :allow_empty_referrer=>true, :report_key=>"protection.failed", :html_types=>["text/html", "application/xhtml", "text/xml", "application/xml"], :frame_options=>:sameorigin, :img_src=>"'self' data:", :font_src=>"'self'", :without_session=>true}>>, "r
# ack.request.query_string"=>"", "rack.request.query_hash"=>{}, "sinatra.route"=>"GET /expenses/:date"}>
