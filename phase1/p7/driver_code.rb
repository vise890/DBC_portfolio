require './bernies_bistro'

puts

puts '###################'
puts 'output for: #list'
puts '###################'
BerniesBistroApp.start(['list'])

puts

puts '###################'
puts 'output for #show(2)'
puts '###################'
BerniesBistroApp.start(['show', '2'])
