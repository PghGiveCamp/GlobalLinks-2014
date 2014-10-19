describe Sinatra::Application do
  include Rack::Test::Methods

  def hasher
    @hasher ||= VolunteerPortal::PasswordHasher.new(salt: ENV['SALT'])
  end

  let! :created_user do
    User.create(
      username: 'known_user',
      password: hasher.hash_password(known_user_password),
      email: 'known-user@example.org',
      volunteer_id: '1'
    )
  end

  let! :volunteer do
    Volunteer.create(
      id: '1',
      username: 'known_user',
      first_name: 'Jane',
      last_name: 'Doe',
      preferred_email: 'jane@doe.com'
    )
  end

  let :rack_session do
    { username: created_user.username, user_id: created_user.id }
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
        last_request.session.each do |key, value|
          last_request.session[key.to_sym] = value
        end
      end

      it 'returns 201' do
        expect(last_response.status).to eq(201)
      end

      it 'sets the user_id in session' do
        expect(last_request.session[:user_id]).to eq(created_user.id)
      end

      it 'sets _li=1 in cookies' do
        expect(rack_mock_session.cookie_jar['_li']).to eq('1')
      end
    end
  end

  describe 'POST /logout' do
    context 'when not signed in' do
      before do
        post '/logout'
      end

      it 'returns 401' do
        expect(last_response.status).to eq(401)
      end
    end

    context 'when signed in' do
      before do
        post '/logout', nil, 'rack.session' => rack_session
      end

      it 'returns 201' do
        expect(last_response.status).to eql(204)
      end

      it 'clears the session' do
        expect(last_request.session).to be_empty
      end

      it 'clears the cookies' do
        expect(rack_mock_session.cookie_jar.to_hash).to be_empty
      end
    end
  end

  describe 'GET /contact' do
    context 'when not logged in' do
      it 'returns 401' do
        get '/contact'
        expect(last_response.status).to eq(401)
      end
    end

    context 'when logged in' do
      it 'returns the contact record' do
        get '/contact', {}, 'rack.session' => rack_session
        expect(last_response).to be_ok
        volunteer = JSON.parse(last_response.body, symbolize_names: true)
        expect(volunteer[:first_name]).to eq('Jane')
        expect(volunteer[:last_name]).to eq('Doe')
      end
    end
  end

  describe 'POST /contact' do
    context 'when not logged in' do
      it 'returns 401' do
        post '/contact'
        expect(last_response.status).to eq(401)
      end
    end

    context 'when logged in' do
      it 'returns the updated contact record' do
        post '/contact',
             { city: 'Houston' },
             'rack.session' => rack_session
        expect(last_response).to be_ok
        puts last_response.body
        volunteer = JSON.parse(last_response.body, symbolize_names: true)
        expect(volunteer[:city]).to eq('Houston')
      end
    end
  end

  describe 'POST /contact/checkin' do
    before do
      volunteer.update(checked_in: false)
    end

    context 'when user is not logged in' do
      it 'returns 401 Unauthorized' do
        post '/contact/checkin'
        expect(last_response).to_not be_ok
        expect(last_response.status).to eq(401)
      end
    end

    context 'when user is logged in' do
      it 'returns 200 OK' do
        post '/contact/checkin', nil, 'rack.session' => rack_session
        expect(last_response).to be_ok
      end

      it 'updates the volunteer\'s checkin property' do
        volunteer.update(checked_in: false)
        post '/contact/checkin', nil, 'rack.session' => rack_session
        volunteer.refresh
        expect(volunteer.checked_in).to be_truthy
        expect(volunteer.last_checkin).to_not be_nil
      end

      context 'when volunteer is already checked in' do
        before do
          volunteer.update(checked_in: true)
        end

        it 'returns 412 Precondition failed' do
          post '/contact/checkin', nil, 'rack.session' => rack_session
          expect(last_response.status).to eq(412)
        end
      end
    end
  end

  describe 'POST /contact/checkout' do
    before do
      volunteer.update(checked_in: true)
    end

    context 'when user is not logged in' do
      it 'returns 401 Unauthorized' do
        post '/contact/checkout'
        expect(last_response).to_not be_ok
        expect(last_response.status).to eq(401)
      end
    end

    context 'when user is logged in' do
      context 'when user is checked in' do
        before do
          volunteer.update(checked_in: true, last_checkin: Time.now - 3600)
        end

        it 'returns 200 OK' do
          post '/contact/checkout', nil, 'rack.session' => rack_session
          expect(last_response).to be_ok
        end

        it 'updates the volunteer\'s checkout property' do
          post '/contact/checkout', nil, 'rack.session' => rack_session
          volunteer.refresh
          expect(volunteer.checked_in).to be_falsey
        end

        it 'updates the volunteer\'s hours' do
          volunteer.update(volunteer_hours: 100)
          post '/contact/checkout', nil, 'rack.session' => rack_session
          volunteer.refresh
          expect(volunteer.volunteer_hours).to eq(101)
        end
      end

      context 'when volunteer is not checked in' do
        before do
          volunteer.update(checked_in: false)
        end

        it 'returns 412 Precondition failed' do
          post '/contact/checkout', nil, 'rack.session' => rack_session
          expect(last_response.status).to eq(412)
        end
      end
    end
  end

  describe 'POST /reset_password_request' do
    context 'when input matches email' do
      it 'returns success' do
        post '/reset_password_request',
             user_identifier: created_user.volunteer.preferred_email
        expect(last_response.status).to eq(201)
      end

      it 'creates reset token' do
        created_user.update(reset_token: nil)
        post '/reset_password_request',
             user_identifier: created_user.volunteer.preferred_email
        created_user.refresh
        expect(created_user.reset_token).to_not be_nil
      end

      xit 'sends email' do
      end
    end

    context 'when input matches username' do
      it 'returns success' do
        post '/reset_password_request',
             user_identifier: created_user.volunteer.username
        expect(last_response.status).to eq(201)
      end

      it 'creates reset token' do
        created_user.update(reset_token: nil)
        post '/reset_password_request',
             user_identifier: created_user.volunteer.username
        created_user.refresh
        expect(created_user.reset_token).to_not be_nil
      end

      xit 'sends email' do
      end
    end

    context 'when input does not match' do
      it 'returns 404' do
        post '/reset_password_request',
             user_identifier: 'foobar'
        expect(last_response.status).to eq(404)
      end

      xit 'does not send email' do
      end
    end
  end

  describe 'POST /reset_password' do
    context 'when token is not found' do
      it 'returns 404' do
        post '/reset_password', reset_token: 'foobar', password: 'abcd'
        expect(last_response.status).to eq(404)
      end
    end

    context 'when token is found' do
      let :token do
        '2d931510-d99f-494a-8c67-87feb05e1594'
      end

      before do
        created_user.update(reset_token: token)
      end

      it 'resets password' do
        post '/reset_password', reset_token: token, password: 'abcd'
        created_user.refresh
        expect(created_user.password).to eq(hasher.hash_password('abcd'))
      end

      it 'clears token' do
        post '/reset_password', reset_token: token, password: 'abcd'
        created_user.refresh
        expect(created_user.reset_token).to be_nil
      end

      it 'returns success' do
        post '/reset_password', reset_token: token, password: 'abcd'
        created_user.refresh
        expect(last_response.status).to eq(200)
      end
    end
  end

  describe 'POST /user' do
    let :volunteer do
      Volunteer.create(
        id: '42',
        preferred_email: 'user@user.com'
      )
    end

    context 'when email not found' do
      it 'responds 404' do
        post '/user', username: 'user',
                      email: 'not@there.com'
        expect(last_response.status).to eq(404)
      end
    end

    context 'when account already exists' do
      it 'responds 409' do
        post '/user', username: 'known_user',
                      email: 'user@user.com'
        expect(last_response.status).to eq(409)
      end
    end

    context 'when a single volunteer is found' do

      context 'when volunteer does not have an username yet' do
        it 'responds 201' do
          post '/user', username: 'user',
                        email: 'user@user.com'
          expect(last_response.status).to eq(201)
        end

        it 'logs the user in' do
          post '/user', username: 'user',
                        email: 'user@user.com'
          expect(last_request.session[:user_id]).to_not be_nil
        end
      end

      context 'when volunteer\'s username matches' do
        let :volunteer do
          Volunteer.create(
            id: '42',
            preferred_email: 'user@user.com',
            username: 'user'
          )
        end
        it 'responds 201' do
          post '/user', username: 'user',
                        email: 'user@user.com'
          expect(last_response.status).to eq(201)
        end

        it 'logs the user in' do
          post '/user', username: 'user',
                        email: 'user@user.com'
          expect(last_request.session[:user_id]).to_not be_nil
        end
      end

      context 'when volunteer\'s username does not match' do
        let :volunteer do
          Volunteer.create(
            id: '42',
            preferred_email: 'user@user.com',
            username: 'nomatch'
          )
        end
        it 'responds 409' do
          post '/user', username: 'user',
                        email: 'user@user.com'
          expect(last_response.status).to eq(409)
        end
      end
    end

    context 'when multiple volunteers are found' do
      before do
        Volunteer.create(
          id: '43',
          preferred_email: 'user@user.com'
        )
      end

      context 'when volunteer\'s username matches one' do
        let :volunteer do
          Volunteer.create(
            id: '42',
            preferred_email: 'user@user.com',
            username: 'user'
          )
        end
        it 'responds 201' do
          post '/user', username: 'user',
                        email: 'user@user.com'
          expect(last_response.status).to eq(201)
        end
        it 'creates a user account' do
          post '/user', username: 'user',
                        email: 'user@user.com'
          user = User.find(username: 'user')
          expect(user).to_not be_nil
          expect(user.volunteer_id).to eq('42')
        end
        it 'logs the user in' do
          post '/user', username: 'user',
                        email: 'user@user.com'
          expect(last_request.session[:user_id]).to_not be_nil
        end
      end

      context 'when volunteer\'s username does not match' do
        it 'responds 409' do
          post '/user', username: 'user',
                        email: 'user@user.com'
          expect(last_response.status).to eq(409)
        end
      end
    end
  end
end
