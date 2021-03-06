before "/admin" do
  redirect "/admin-login" if !session['admin']
end

before "/admin*" do
  @models = [Post, Comment, Mention, Tag, User]
end

before "/admin/*" do
  redirect "/admin-login" if !session['admin']
  /\/admin\/(?<model_name>\w+)/ =~ request.path
  next if (!model_name or model_name == 'secret')
  @model = Module.const_get(model_name.camelize) rescue next
  if @model.respond_to?(:admin_fields)
    @fields = @model.admin_fields
  else
    @fields = []
    @model.column_names.each do |name|
      type = @model.columns_hash[name].type
      next if %w[type id created_at updated_at deleted_at].include?(name)
      desc = (type == :hstore ? ' (hash)' : nil)
      field_type = type == :boolean ? 'checkbox' : name =~ /^(content|content_html)$/ ? 'textarea' : 'text'
      @fields << [name, field_type, desc]
    end
  end
end

get "/admin-login" do
  slim (Pref.initialized? ? :'admin/login' : :'admin/secret'), layout: :admin
end

post "/admin-login" do
  if !Pref.initialized?
    if params[:p] != params[:p_confirm] or params[:p].size < 6
      @error = "Password not match or too short"
      slim :'admin/secret', layout: :admin
    else
      Pref.admin_password = params[:p]
      session['admin'] = true
      flash[:notice] = "Admin data initialized"
      redirect "/admin"
    end
  elsif !(Pref.validate_admin_password params[:p])
    slim :'admin/login', layout: :admin
  else
    session['admin'] = true
    redirect "/admin"
  end
end

get "/admin-logout" do
  session.delete 'admin'
  flash[:notice] = 'Logged out'
  redirect "/admin-login"
end

get "/admin/?" do
  slim :'admin/index', layout: :admin
end

get "/admin/secret" do
  slim :'admin/secret', layout: :admin
end

post "/admin/secret" do
  if params[:p] != params[:p_confirm] or params[:p].size < 6
    @error = "Password not match or too short"
    slim :'admin/secret', layout: :admin
  else
    Pref.admin_password = params[:p]
    flash[:notice] = "Updated"
    redirect "/admin"
  end
end

get "/admin/:model/?" do
  per_page = 20
  current_page = params[:p].to_i - 1
  current_page = 0 if current_page < 0
  @field_names = @model.column_names.select do |name|
    ! %w[type id created_at updated_at deleted_at].include? name
  end
  @objects = @model.unscoped.order('created_at desc').offset(current_page * per_page).limit(per_page)
  slim :'model/index', layout: :admin
end

get "/admin/:model/new" do
  @object = @model.new
  slim :'model/new', layout: :admin
end

post "/admin/:model/?" do |model|
  @object = @model.new
  ActiveRecord.assign_jsonify_attrs @object, params[model.singularize]
  # tricky: @object.errors.empty? will remove errors
  if @object.errors.to_hash.empty? and @object.save
    flash[:notice] = 'created.'
    redirect "/admin/#{model}/#{@object.id}/edit"
  else
    slim :'model/new', layout: :admin
  end
end

get "/admin/:model/:id/edit" do |model, id|
  @object = @model.unscoped.find id
  slim :'model/edit', layout: :admin
end

put "/admin/:model/:id/?" do |model, id|
  @object = @model.unscoped.find id
  ActiveRecord.assign_jsonify_attrs @object, params[model.singularize]
  if @object.errors.to_hash.empty? and @object.save
    flash[:notice] = 'updated.'
    redirect "/admin/#{model}/#{id}/edit"
  else
    slim :'model/edit', layout: :admin
  end
end

post "/admin/:model/:id/restore" do |model, id|
  object = @model.unscoped.find id
  # NOTE cookie size may exceed 4k
  flash[:notice] = (object.restore ? 'restored' : 'failed to restore') rescue [$!, $!.backtrace.first].join("\n")
  redirect "/admin/#{model}"
end

delete "/admin/:model/:id/?" do |model, id|
  object = @model.unscoped.find id
  flash[:notice] = (object.destroy ? 'destroyed' : 'failed to destroy') rescue [$!, $!.backtrace.first].join("\n")
  redirect "/admin/#{model}"
end
