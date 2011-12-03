helpers do
  def openid_consumer
    @openid_consumer ||= OpenID::YavaConsumer.new session
  end

  def remember_me user
    # NOTE cookies[] is string key only
    if request.cookies['openid_remember'] == 'on'
      response.set_cookie 'remember_me',
        path: '/',
        value: Secret.encrypt(user.id.to_s),
        expires: Time.now.next_month,
        httponly: true
    end
  end

  def forget_me
    # XXX delete_cookie doesn't work
    response.set_cookie 'remember_me',
      path: '/',
      value: "",
      expire_after: 60,
      httponly: true
  end

  # call-seq:
  #
  #   == form @post, action: '/a/b', method: 'delete' do |f|
  #     == f.text 'nick'
  #
  #   == form action: '/a/b', method: 'get' do
  #     input type='text' name='n' value='xx'
  #
  # Default method is POST, also adds csrf token, simulates PUT and DELETE with _method.
  def form obj, params=nil
    if params.nil?
      params = obj
      body = yield
    else
      body = yield FormProxy.new obj
    end
    params = params.symbolize_keys
    method = (params.delete(:method) or 'post')
    params[:'accept-charset'] ||= 'UTF-8'
    if method =~ /^(put|delete)$/
      method_override = "<input type='hidden' name='_method' value='#{method}'></input>"
      method = 'post'
    end
    params = params.to_attrs
    "<form method='#{method}' #{params}>#{csrf}#{method_override}#{body}</form>"
  end

  def csrf
    "<input type='hidden' name='authenticity_token' value='#{session[:csrf]}'></input>"
  end

  def meta_csrf
    "<meta name='csrf-param' content='authenticity_token'/><meta name='csrf-token' content='#{session[:csrf]}'/>"
  end

  # File actionpack/lib/action_view/helpers/date_helper.rb, line 67
  def distance_of_time(from_time, to_time = Time.now, include_seconds = false, options = {})
    return if !from_time
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    I18n.with_options :locale => options[:locale], :scope => :'datetime.distance_in_words' do |locale|
      case distance_in_minutes
      when 0..1
        return distance_in_minutes == 0 ?
               locale.t(:less_than_x_minutes, :count => 1) :
               locale.t(:x_minutes, :count => distance_in_minutes) unless include_seconds

        case distance_in_seconds
        when 0..4   then locale.t :less_than_x_seconds, :count => 5
        when 5..9   then locale.t :less_than_x_seconds, :count => 10
        when 10..19 then locale.t :less_than_x_seconds, :count => 20
        when 20..39 then locale.t :half_a_minute
        when 40..59 then locale.t :less_than_x_minutes, :count => 1
        else             locale.t :x_minutes,           :count => 1
        end

      when 2..44           then locale.t :x_minutes,      :count => distance_in_minutes
      when 45..89          then locale.t :about_x_hours,  :count => 1
      when 90..1439        then locale.t :about_x_hours,  :count => (distance_in_minutes.to_f / 60.0).round
      when 1440..2519      then locale.t :x_days,         :count => 1
      when 2520..43199     then locale.t :x_days,         :count => (distance_in_minutes.to_f / 1440.0).round
      when 43200..86399    then locale.t :about_x_months, :count => 1
      when 86400..525599   then locale.t :x_months,       :count => (distance_in_minutes.to_f / 43200.0).round
      else
        fyear = from_time.year
        fyear += 1 if from_time.month >= 3
        tyear = to_time.year
        tyear -= 1 if to_time.month < 3
        leap_years = (fyear > tyear) ? 0 : (fyear..tyear).count{|x| Date.leap?(x)}
        minute_offset_for_leap_year = leap_years * 1440
        # Discount the leap year days when calculating year distance.
        # e.g. if there are 20 leap year days between 2 dates having the same day
        # and month then the based on 365 days calculation
        # the distance in years will come out to over 80 years when in written
        # english it would read better as about 80 years.
        minutes_with_offset         = distance_in_minutes - minute_offset_for_leap_year
        remainder                   = (minutes_with_offset % 525600)
        distance_in_years           = (minutes_with_offset / 525600)
        if remainder < 131400
          locale.t(:about_x_years,  :count => distance_in_years)
        elsif remainder < 394200
          locale.t(:over_x_years,   :count => distance_in_years)
        else
          locale.t(:almost_x_years, :count => distance_in_years + 1)
        end
      end
    end
  end
end

