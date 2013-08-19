get '/' do
  erb :index
end

get '/skills/:skill' do
  erb :skills
end

get '/meals' do
  @meals = ["Spaghetti",
            "Ravioli",
            "Hummus and Veggies",
            "Pizza",
            "Falafel",
            "Sushi",
            "Linguini",
            "Onigilli"].to_json
  erb :meals
end

# this route is only used as AJAX fallback
# in the current implementation, cookies are
# set in the client through a jQuery plugin
post '/color' do
  response.set_cookie('color', value: params[:color],
            domain: '',
            path: '/', # root and all subdirs (i.e., all pages)
           )
  redirect '/'
end
