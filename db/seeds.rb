# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Article.destroy_all

Article.create!([
  {
    title: "The Rise of Electric Cars",
    content: "Electric cars are becoming more popular as battery technology improves and charging stations become more accessible."
  },
  {
    title: "Best Practices for Remote Work",
    content: "To stay productive while working remotely, it helps to create a dedicated workspace and establish a routine."
  },
  {
    title: "Healthy Eating on a Budget",
    content: "Eating healthy doesn't have to be expensive. With a little planning, you can prepare nutritious meals without breaking the bank."
  },
  {
    title: "How to Learn Programming",
    content: "Learning to program is easier today than ever before. Start with a beginner-friendly language like Python or Ruby."
  },
  {
    title: "Travel Tips for First-Time Backpackers",
    content: "Pack light, plan ahead, and always keep your passport and valuables secure when backpacking abroad."
  }
])

puts "Seeded #{Article.count} articles."
