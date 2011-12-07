# http://gehling.dk/2010/02/how-to-make-rails-routing-case-insensitive/
class DowncaseRouteMiddleware

  def initialize(app)
    @app = app
  end

  def call(env)    
    # Rails 3.x routing use PATH_INFO
    env['PATH_INFO'] = env['PATH_INFO'].downcase unless env['PATH_INFO'] =~ /\/assets\//i
    
    @app.call(env)
  end

end
