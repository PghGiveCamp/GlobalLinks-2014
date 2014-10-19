require_relative 'app'
require 'erb'

module VolunteerPortal
  class StaleCheckinProcessor
    def initialize(limit)
      @limit = limit.to_i
    end

    def process_stale_checkins
      time = Time.now - @limit
      volunteers = Volunteer.where(checked_in: true) do
        last_checkin < time
      end

      volunteers.each do |volunteer|
        next unless volunteer.user &&
          (volunteer.user.last_stale_email_at.nil? ||
           volunteer.user.last_stale_email_at < volunteer.last_checkin)

        Pony.mail(to: volunteer.preferred_email,
                  subject: 'Your shift is still open',
                  html_body: html_body(volunteer),
                  body: body(volunteer))
      end
    end

    def body(_volunteer)
      b = binding
      ERB.new(<<-'END_BODY'.gsub(/^\s+/, '')).result b
        <%= _volunteer.first_name %>,

        You are still checked in to your shift. To check out, go to
        <%= checkout_url %>.

        Thank you,
        Global Links
      END_BODY
    end

    def html_body(_volunteer)
      b = binding
      ERB.new(<<-'END_BODY'.gsub(/^\s+/, '')).result b
        <p>
          <%= _volunteer.first_name %>,
        </p>
        <p>
          You are still checked in to your shift. To check out, go to
          <a href="<%= checkout_url %>"><%= checkout_url %></a>.
        </p>
        <p>
          Thank you,
          Global Links
        </p>
      END_BODY
    end

    def checkout_url
      "#{ENV['SITE_URL']}#/checkin"
    end
  end
end
