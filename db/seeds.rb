# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Post.destroy_all
Comment.destroy_all

100.times do
    post_db = Post.create(
        title: Faker::Book.title, # Using random book titles for the post titles
        body: Faker::Lorem.paragraph, # Using pseudo-Latin for the body of the posts
        created_at: Faker::Date.backward(days:365 * 5),
        updated_at: Faker::Date.backward(days:365 * 5)
    )
    if post_db.valid?
        post_db.comments = rand(0..40).times.map do
            Comment.new(body: Faker::TvShows::Simpsons.quote)
        end
    end
end

posts = Post.all
comments = Comment.all

puts Cowsay.say("Generated #{Post.count} posts", :sheep)
puts Cowsay.say("Generated #{Comment.count} posts", :beavis)