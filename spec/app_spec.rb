describe Sinatra::Application do
  include Rack::Test::Methods

  before do
    @user = User.create(
      username: 'known_user',
      password: '64250fca9eebcfa7259c70bbc5a48fc84579937a',
      email: 'known-user@example.org',
      volunteer_id: '1'
    )
    @volunteer = Volunteer.create(
      id: '1',
      first_name: 'John',
      last_name: 'Doe'
    )
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

  describe 'GET /contact' do
    context 'when not logged in' do
      it 'returns 404' do
        get '/contact'
        expect(last_response.status).to eq(404)
      end
    end

    context 'when logged in' do
      it 'returns the contact record' do
        get '/contact', {}, 'rack.session' => {user_id: @user.id}
        expect(last_response).to be_ok
        volunteer = JSON.parse(last_response.body, symbolize_names: true)
        expect(volunteer[:first_name]).to eq('John')
        expect(volunteer[:last_name]).to eq('Doe')
      end
    end
  end
end
