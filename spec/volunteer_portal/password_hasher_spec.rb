describe VolunteerPortal::PasswordHasher do
  subject { described_class.new(salt: 'abc123') }

  it 'hashes well' do
    # rubocop: disable Metrics/LineLength
    {
      'fancypass' => '5b2d0b0afc165848522b1b10b25a3b12ac7db1a27d2499003035ac9712058c6c69b36db05ee879aebe8c4fba4c75446f3330ef3b007b9cb8e31c06c36df8087b',
      'ev3nm0r3f4ncyP455!!!?&*&*' => 'bdefbd6fdfa08812536694a332c44159a8770874e32f75f02e9a0962c79865bc391dfb97fcfb28d8dab9451dce614deb97557ccb03b9951d8d683b6ed2359125'
    }.each do |input, output|
      expect(subject.hash_password(input)).to eql(output)
    end
    # rubocop: enable Metrics/LineLength
  end
end
