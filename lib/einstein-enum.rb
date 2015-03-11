if defined?(Motion::Project::Config)
  Motion::Project::App.setup do |app|
    app.files << File.join(File.dirname(__FILE__), 'enum.rb')
  end
else
  require File.join(File.dirname(__FILE__), 'enum.rb')
end
