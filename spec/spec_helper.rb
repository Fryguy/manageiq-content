require 'manageiq-content'

# Reset only the ManageIQ automate domain when testing.
ENV["AUTOMATE_DOMAINS"] = "ManageIQ"

def require_domain_file
  spec_name = caller_locations.first.path
  file_name = spec_name.sub("spec/", "").sub("_spec.rb", ".rb")

  require file_name
end

RSpec.configure do |config|
  config.include Spec::Support::AutomationHelper

  config.before(:suite) do
    puts "** Resetting #{ENV["AUTOMATE_DOMAINS"]} domain(s)"
    Tenant.seed
    MiqAeDatastore.reset
    MiqAeDatastore.reset_to_defaults
  end

  config.after(:suite) do
    MiqAeDatastore.reset
  end
end
