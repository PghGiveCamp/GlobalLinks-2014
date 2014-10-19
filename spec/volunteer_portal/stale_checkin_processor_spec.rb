describe VolunteerPortal::StaleCheckinProcessor do
  subject { described_class.new(10) }

  before do
    User.create(
      volunteer_id: '1',
      username: 'stale',
      email: 'stale@example.com',
      password: ''
    )
  end

  it 'sends an email to stale checkins' do
    Volunteer.create(
      id: '1',
      first_name: 'Simon',
      preferred_email: 'stale@example.com',
      checked_in: true,
      last_checkin: Time.now - 11
    )
    expect(Pony).to receive(:mail) do |params|
      expect(params[:to]).to eq('stale@example.com')
    end

    subject.process_stale_checkins
  end

  it 'does not send an email for checkins less than the limit' do
    Volunteer.create(
      id: '1',
      preferred_email: 'stale@example.com',
      checked_in: true,
      last_checkin: Time.now - 9
    )
    expect(Pony).not_to receive(:mail)

    subject.process_stale_checkins
  end

  it 'does not send an email for volunteers not checked in' do
    Volunteer.create(
      id: '1',
      preferred_email: 'stale@example.com',
      checked_in: false,
      last_checkin: Time.now - 11
    )
    expect(Pony).not_to receive(:mail)

    subject.process_stale_checkins
  end

  it 'does not send an email if the volunteer does not have an account' do
    Volunteer.create(
      id: '2',
      preferred_email: 'stale@example.com',
      checked_in: true,
      last_checkin: Time.now - 11
    )
    expect(Pony).not_to receive(:mail)

    subject.process_stale_checkins
  end

  it 'does not send an email if we already sent one' do
    User.create(
      volunteer_id: '2',
      username: 'stale',
      email: 'stale@example.com',
      password: '',
      last_stale_email_at: Time.now
    )
    Volunteer.create(
      id: '2',
      preferred_email: 'stale@example.com',
      checked_in: true,
      last_checkin: Time.now - 11
    )
    expect(Pony).not_to receive(:mail)

    subject.process_stale_checkins
  end
end
