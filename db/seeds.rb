# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@user = User.create!(name:  "Admin User",
             email: "testforum63@gmail.com",
             password:              "password",
             password_confirmation: "password",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

@other_user = User.create!(name:  "Other User",
             email: "testforum096@gmail.com",
             password:              "password",
             password_confirmation: "password",
             admin: false,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "email-#{n+1}@testforum.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

@forum = Array.new
11.times do |n|
  @forum.push Forum.create!(
               title:  "Forum-#{n}")
  @topic ||= Array.new
  20.times do |m|
    @topic.push @forum[n].topics.create!(
                 title: "Topic-#{Faker::Lorem.sentence(Random.rand(1...6))}",
                 first_post_content: Faker::Lorem.sentence(Random.rand(10...100)),
                 forum_id: @forum[n].id)
    @post ||= Array.new
    @other_post ||= Array.new
    20.times do |o|
      @post.push @topic[m].posts.create!(
                   content:  Faker::Lorem.sentence(Random.rand(10...100)),
                   topic_id: @topic[m].id,
                   user_id: @user.id)
      @topic[m].update_columns(last_post_id: @post[o].id)
      @other_post.push @topic[m].posts.create!(
                   content:  Faker::Lorem.sentence(Random.rand(10...100)),
                   topic_id: @topic[m].id,
                   user_id: @other_user.id)
      @topic[m].update_columns(last_post_id: @other_post[o].id)
    end
    @post.clear
    @other_post.clear
  end
  @topic.clear
end

Forum.create!(title:  "Empty Forum")

