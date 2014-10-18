describe Sinatra::Application do
  include Rack::Test::Methods

  before do
    if app.database[:users].filter(username: 'known_user').empty?
      User.create(
        username: 'known_user',
        password: '64250fca9eebcfa7259c70bbc5a48fc84579937a',
        email: 'known-user@example.org',
        volunteer_id: '1'
      )
    end
  end

  def app
    Sinatra::Application
  end

  describe 'GET /' do
    it 'is for real' do
      get '/'
      expect(last_response).to be_ok
    end
  end

  describe 'POST /login' do
    context 'when no username is supplied' do
      it 'errors out' do
        post '/login', {}
        expect(last_response).to_not be_ok
        expect(last_response.status).to eq(400)
      end
    end

    context 'when known username is supplied' do
      it 'succeeds' do
        post '/login',
             username: 'known_user',
             password: '64250fca9eebcfa7259c70bbc5a48fc84579937a'
        expect(last_response.status).to eq(201)
      end
    end
  end
end
