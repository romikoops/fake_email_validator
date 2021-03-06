require 'mail'

class FakeEmailException < StandardError
end

class FakeEmailService

  def initialize
    fake_domains_file = File.expand_path('../../config/fake_domains.list', __FILE__)
    @fake_domains = File.readlines(fake_domains_file).map {|fd| fd.strip.downcase }
  end

  def is_fake_email?(email)
    email_address = Mail::Address.new(email)

    domain = email_address.domain

    raise FakeEmailException, 'Domain part in email is not present' if domain.blank?

    domain = domain.strip.downcase
    domain_parts = domain.split('.')

    second_level_domain = Array(domain_parts[-2..-1]).join('.')
    third_level_domain = Array(domain_parts[-3..-1]).join('.')

    domains = [domain, second_level_domain, third_level_domain].compact

    @fake_domains.any? {|fake_domain| domains.include?(fake_domain) }
  end

end