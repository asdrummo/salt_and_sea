ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "saltandsea.me",
  :user_name            => "justinecsimon",
  :password             => "uuaqxdryoqafylnp",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
require 'development_mail_interceptor'
ActionMailer::Base.default_url_options[:host] = "marketplace.saltandsea.me"
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?