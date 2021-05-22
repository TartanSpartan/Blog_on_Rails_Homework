# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

PASSWORD = "justinbailey" # Inspired by a classic video game password


Post.destroy_all
Comment.destroy_all
User.destroy_all

# Set up a user with admin privileges
admin_user = User.create(
    first_name: "Seumas",
    last_name: "Finlayson",
    email: "seumasfinlayson@googlemail.com",
    password: PASSWORD,
    is_admin: true
)

20.times do 
    first_name = Faker::Name.first_name 
    last_name = Faker::Name.last_name 
    User.create( 
        first_name: first_name, 
        last_name: last_name,  
        email: "#{first_name.downcase}.#{last_name.downcase}@example.com", 
        password: PASSWORD 
    )  
end 

users = User.all

100.times do
    user = users.sample
    post_db = Post.create(
        title: Faker::Book.title, # Using random book titles for the post titles
        body: Faker::Lorem.paragraph, # Using pseudo-Latin for the body of the posts
        created_at: Faker::Date.backward(days:365 * 5),
        updated_at: Faker::Date.backward(days:365 * 5),
        user_id: user.id
    )
    if post_db.valid?
        post_db.comments = rand(0..40).times.map do
            user = users.sample
            Comment.new(body: Faker::TvShows::Simpsons.quote, user_id: user.id)
        end
    end
end

posts = Post.all
comments = Comment.all

puts Cowsay.say("Generated #{Post.count} posts", :sheep)
puts Cowsay.say("Generated #{Comment.count} comments", :beavis)
puts Cowsay.say("Generated #{User.count} users", :cow)  
puts "Sign In with #{admin_user.email} and password of '#{PASSWORD}'"