module Rack
  YavaProtection = Struct.new(:app)
  class YavaProtection
    SAFE_VERBS = %w[GET HEAD OPTIONS TRACE]

    def call env
      # CSRF
      unless SAFE_VERBS.include?(env['REQUEST_METHOD'])
        if env['rack.session'][:csrf] != Request.new(env).params['authenticity_token']
          env['rack.session'] = {}
        end
      end
      env['rack.session'][:csrf] ||= rand_string

      status, headers, body = app.call env

      # prevent IE8 non-permanent XSS
      headers['X-XSS-Protection'] = '1; mode=block'
      [status, headers, body]
    end

    def rand_string
      "%032x" % rand(2**128-1)
    end
  end
end