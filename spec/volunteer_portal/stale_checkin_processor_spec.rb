describe VolunteerPortal::StaleCheckinProcessor do
  subject { described_class.new(10) }

  xit 'sends an email to stale checkins' do
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

  xit 'does not send an email for checkins less than the limit' do
    Volunteer.create(
      id: '1',
      preferred_email: 'stale@example.com',
      checked_in: true,
      last_checkin: Time.now - 9
    )
    expect(Pony).not_to receive(:mail)

    subject.process_stale_checkins
  end

  xit 'does not send an email for volunteers not checked in' do
    Volunteer.create(
      id: '1',
      preferred_email: 'stale@example.com',
      checked_in: false,
      last_checkin: Time.now - 11
    )
    expect(Pony).not_to receive(:mail)

    subject.process_stale_checkins
  end
end
