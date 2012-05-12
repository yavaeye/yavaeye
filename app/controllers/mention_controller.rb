get "/mentions" do
  authenticate!
  current_user.mentions.paginate params[:page]
end
