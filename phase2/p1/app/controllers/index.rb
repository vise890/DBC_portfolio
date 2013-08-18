get '/' do
  redirect '/notes'
end

get '/notes/new' do
  erb :note_form
end

post '/notes' do
  Note.create(params)
  redirect '/notes'
end

get '/notes' do
  @notes = Note.all
  erb :index
end

get '/notes/:id' do
  @note = Note.find_by_id(params[:id])
  erb :note
end

get '/notes/:id/edit' do
  @note = Note.find_by_id(params[:id])
  erb :note_form
end

put '/notes/:id' do
  note = Note.find_by_id(params[:id])
  note.title = params[:title]
  note.content = params[:content]
  note.save
  redirect '/notes'
end

delete '/notes/:id' do
  Note.find_by_id(params[:id]).destroy
  redirect '/notes'
end
