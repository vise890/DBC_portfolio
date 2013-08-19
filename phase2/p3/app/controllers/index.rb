before do
  @errors = session.delete(:errors) || []
end

get '/' do
  @users = User.all if logged_in?
  haml :index
end

#----------- SESSIONS -----------

get '/sessions/new' do
  haml :sign_in
end

post '/sessions' do
  user = User.authenticate(params[:email], params[:password])
  if user
    session[:user_id] = user.id
    redirect to '/'
  elsif
    session[:errors] = ['Invalid Login']
    redirect to '/sessions/new'
  end
end

delete '/sessions/:id' do
  session.delete(params[:id])
  redirect to '/'
end

#----------- USERS -----------

get '/users/new' do
  haml :sign_up
end

post '/users' do
  user = User.create(params[:user])
  session[:errors] = user.errors.full_messages
  redirect to '/'
end
