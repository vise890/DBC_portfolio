before do
  @errors = session.delete(:errors) || {}
end

get '/' do
  @events = Event.all
  erb :index
end

get '/events/:id/show' do |id|
  @event = Event.find(id)
  erb :event_show
end

get '/events/new' do
  @event = session[:event] || Event.new
  erb :event_new
end

post '/events/new' do
  event = Event.create(params[:event])
  errors = event.errors
  if errors.any?
    session[:errors] = errors
    session[:event] = event
    redirect to '/events/new'
  else
    session.delete(:event)
    redirect to '/'
  end
end
