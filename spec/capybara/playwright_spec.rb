# frozen_string_literal: true

require 'spec_helper'
require 'capybara/spec/spec_helper'

module TestSessions
  Playwright = Capybara::Session.new(:playwright, TestApp)
end

Capybara::SpecHelper.run_specs TestSessions::Playwright, 'Playwright' do |example|
  case example.metadata[:full_description]
  when /should offset outside (the|from center of) element/
    pending 'Playwright does not allow to click outside the element'
  when /should not retry clicking when wait is disabled/
    pending 'wait = 0 is not supported'
  when /when details is toggled open and closed/
    pending "NoMethodError: undefined method `and' for #<Capybara::RSpecMatchers::Matchers::HaveSelector:0x00007f9bafd56900>"
  when /Element#drop/
    pending 'not implemented'
  when /drag_to.*HTML5/
    skip 'not supported yet in Playwright driver'
  when /Playwright Capybara::Window#maximize/,
       /Playwright Capybara::Window#fullscreen/
    skip 'not supported in Playwright driver'
  when /Playwright #has_field with validation message/
    # HTML5 validation message is a bit different.
    #  expected: /match the requested format/
    #  obserbed: "Match the requested format"
    pending 'HTML5 validation message is a bit different.' if ENV['BROWSER'] == 'webkit'
  when /Playwright #refresh it reposts/
    # ref: https://github.com/teamcapybara/capybara/blob/f7ab0b5cd5da86185816c2d5c30d58145fe654ed/spec/selenium_spec_safari.rb#L62
    pending "WebKit opens an alert that can't be closed" if ENV['BROWSER'] == 'webkit'
  when /shadow_root should produce error messages when failing/
    pending "Probably Capybara would assume only Selenium driver."
  end

  Capybara::SpecHelper.reset!
end
