describe Sinatra::Application do
  include Rack::Test::Methods

  before do
    create_user! if
      app.database[:users].filter(username: 'known_user').empty?
  end

  def create_user!
    created_user
  end

  def created_user
    @created_user ||= begin
      User.find(username: 'known_user') || User.create(
        username: 'known_user',
        password: '64250fca9eebcfa7259c70bbc5a48fc84579937a',
        email: 'known-user@example.org',
        volunteer_id: '1'
      )
    end
    if app.database[:volunteers].filter(id: '1').empty?
      Volunteer.create(id: '1')
    end
    @created_user
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
             username: created_user.username,
             password: created_user.password
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
        expect(last_request.session[:user_id]).to eq(created_user.id)
      end

      it 'sets _li=1 in cookies' do
        expect(rack_mock_session.cookie_jar['_li']).to eq('1')
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
