describe Sinatra::Application do
  include Rack::Test::Methods

  before do
    create_user! if
      app.database[:users].filter(username: 'known_user').empty?
  end

  def hasher
    @hasher ||= GlobalLinks::PasswordHasher.new(salt: ENV['SALT'])
  end

  def create_user!
    created_user
  end

  def created_user
    @created_user ||= begin
      found = User.find(username: 'known_user')
      if found
        found.password = hasher.hash_password(known_user_password)
        found.save
        found
      else
        User.create(
          username: 'known_user',
          password: hasher.hash_password(known_user_password),
          email: 'known-user@example.org',
          volunteer_id: '1'
        )
      end
    end
  end

  def known_user_password
    @known_user_password ||= 'notasecret' << "#{rand(100..999)}"
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
             password: known_user_password
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
end
