# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'bundler' do
  watch('Gemfile')
  # Uncomment next line if Gemfile contain `gemspec' command
  # watch(/^.+\.gemspec/)
end

group :backend do 
  guard 'spork', :wait => 50, :cucumber => false, :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' }, :bundler => true do
    watch('config/application.rb')
    watch('config/environment.rb')
    watch(%r{^config/environments/.+\.rb$})
    watch(%r{^config/initializers/.+\.rb$})
    watch('spec/spec_helper.rb')
    watch('spec/factories.rb')
  end

  guard 'rspec', :cli => '--drb --color' do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { "spec/" }

    # Rails example
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^spec/controllers/(.+)_spec\.rb$})         { |m| "spec/controllers/#{m[1]}_spec.rb" }
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
    watch(%r{^spec/support/(.+)\.rb$})                  { "spec/" }
    watch('spec/spec_helper.rb')                        { "spec/" }
    watch('config/routes.rb')                           { "spec/routing" }
    watch('app/controllers/application_controller.rb')  { "spec/controllers" }
    # Capybara request specs
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
  end
end

group :features do
  guard 'spork', :wait => 50, :cucumber => true, :cucumber_env => { 'RAILS_ENV' => 'cucumber' }, :rspec_env => { 'RAILS_ENV' => 'cucumber' }, :bundler => true do watch('config/application.rb')
    watch('config/environment.rb')
    watch(%r{^config/environments/.+\.rb$})
    watch(%r{^config/initializers/.+\.rb$})
    watch('spec/spec_helper.rb')
    watch('spec/factories.rb')
  end

  guard 'cucumber', :cli => '--drb --format progress --no-profile' do
    watch(%r{^features/(.+)\.feature$})                   { |m| "#{m[1]}.feature" }
    watch(%r{^features/support/.+$})                      { 'features' }
    watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
  end
end

