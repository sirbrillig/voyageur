if defined?(Konacha)
  Konacha.configure do |config|
    require 'rspec/core'
    require 'rspec/core/configuration'
    require 'rspec/core/formatters/documentation_formatter'
    # require 'capybara/poltergeist'
    # config.driver       = :poltergeist
    # RSpec.configure { |c| c.color_enabled = true }
    config.formatters   = [RSpec::Core::Formatters::DocumentationFormatter.new(STDOUT)]
  end
end
