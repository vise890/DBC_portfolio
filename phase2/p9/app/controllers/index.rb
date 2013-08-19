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

post '/color' do
  response.set_cookie('color', value: params[:color],
            domain: '',
            path: '/', # root and all subdirs (i.e., all pages)
           )
  redirect '/'
end
