helpers do
  def initialize_admin 
    Secret.admin_password = params[:p]
    Secret.session_secret = (params[:secret] + 'x12#!Dsf9(&aO~)' * 16)[0...256]
  end
end