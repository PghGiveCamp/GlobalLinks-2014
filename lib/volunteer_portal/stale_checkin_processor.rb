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
        notify_volunteer(volunteer)
      end
    end

    def notify_volunteer(volunteer)
      Pony.mail(
        to: volunteer.preferred_email,
        subject: 'Your shift is still open',
        html_body: html_body(volunteer),
        body: body(volunteer)
      )
    end

    def body(_volunteer)
      local_binding = binding
      ERB.new(TEXT_BODY).result(local_binding)
    end

    def html_body(_volunteer)
      local_binding = binding
      ERB.new(HTML_BODY).result(local_binding)
    end

    def checkout_url
      "#{ENV['SITE_URL']}#/checkin"
    end

    HTML_BODY = <<-EOF.gsub(/^ {4}/, '')
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
    EOF

    TEXT_BODY = <<-EOF.gsub(/^ {4}/, '')
    <%= _volunteer.first_name %>,

    You are still checked in to your shift. To check out, go to
    <%= checkout_url %>.

    Thank you,
    Global Links
    EOF
  end
end
