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
      before :each do
        post '/login', {}
      end

      it 'responds 400' do
        expect(last_response.status).to eq(400)
      end
    end

    context 'when known username is supplied' do
      before :each do
        post '/login',
          username: @user.username,
          password: @user.password
        last_request.session.each do |key, value|
          last_request.session[key.to_sym] = value
        end
      end

      it 'returns 201' do
        expect(last_response.status).to eq(201)
      end

      it 'sets the username in session' do
        expect(last_request.session[:username]).to eq('known_user')
      end

      it 'sets the user_id in session' do
        expect(last_request.session[:user_id]).to eq(@user.id)
      end

      it 'sets _li=1 in cookies' do
        expect(rack_mock_session.cookie_jar['_li']).to eq('1')
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

  describe 'POST /checkin' do
    before do
      Volunteer.find(id: '1').update(checked_in: false)
    end

    context 'when user is not logged in' do
      it 'returns 403 Unauthorized' do
        post '/checkin'
        expect(last_response).to_not be_ok
        expect(last_response.status).to eq(401)
      end
    end

    context 'when user is logged in' do
      before do
        post '/login',
          username: 'known_user',
          password: '64250fca9eebcfa7259c70bbc5a48fc84579937a'
      end

      it 'returns 200 OK' do
        post '/checkin'
        expect(last_response).to be_ok
      end

      it 'updates the volunteer\'s checkin property' do
        volunteer = Volunteer.find(id: '1')
        volunteer.update(checked_in: false)
        post '/checkin'
        volunteer.refresh
        expect(volunteer.checked_in).to be_truthy
        expect(volunteer.last_checkin).to_not be_nil
      end

      context 'when volunteer is already checked in' do
        before do
          Volunteer.find(id: '1').update(checked_in: true)
        end

        it 'returns 409 Conflict' do
          post '/checkin'
          expect(last_response.status).to eq(409)
        end
      end
    end
  end
end
