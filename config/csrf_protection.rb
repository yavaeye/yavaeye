module Rack
  CsrfProtection = Struct.new(:app)

  class CsrfProtection
    SAFE_VERBS = %w[GET HEAD OPTIONS TRACE]

    def call env
      unless SAFE_VERBS.include?(env['REQUEST_METHOD'])
        if env['rack.session'][:csrf] != Request.new(env).params['authenticity_token']
          env['rack.session'] = {}
        end
      end
      env['rack.session'][:csrf] ||= ("%032x" % rand(2**128-1))

      app.call env
    end
  end
end
