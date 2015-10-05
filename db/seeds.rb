# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@user = User.create!(name:  "Admin User",
             email: "admin@testforum.com",
             password:              "password",
             password_confirmation: "password",
             admin: true,
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

@first_forum = Forum.create!(title:  "First Forum")
@second_forum = Forum.create!(title:  "Second Forum")

@first_forum_first_topic = @first_forum.topics.create!(
       title: "First Forum, First Topic", forum_id: @first_forum.id)
@first_forum_second_topic = @first_forum.topics.create!(
       title: "First Forum, Second Topic", forum_id: @first_forum.id)
@second_forum_first_topic = @second_forum.topics.create!(
       title: "Second Forum, First Topic", forum_id: @second_forum.id)
@second_forum_second_topic = @second_forum.topics.create!(
       title: "Second Forum, Second Topic", forum_id: @second_forum.id)

@first_forum_first_topic.posts.create!(
       content: "First Post",
       topic_id: @first_forum_first_topic.id,
       user_id: @user.id)
@first_forum_second_topic.posts.create!(
       content: "Second Post",
       topic_id: @first_forum_second_topic.id,
       user_id: @user.id)
@second_forum_first_topic.posts.create!(
       content: "Third Post",
       topic_id: @second_forum_first_topic.id,
       user_id: @user.id)
@second_forum_second_topic.posts.create!(
       content: "Fourth Post",
       topic_id: @second_forum_second_topic.id,
       user_id: @user.id)

