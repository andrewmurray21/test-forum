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

@forum = Array.new
11.times do |n|
  @forum.push Forum.create!(
               title:  "Forum-#{n}")
  @topic ||= Array.new
  20.times do |m|
    @topic.push @forum[n].topics.create!(
                 title: "Topic-#{m}",
                 first_post_content: "content-0",
                 forum_id: @forum[n].id)
    @post ||= Array.new
    20.times do |o|
      @post.push @topic[m].posts.create!(
                   content:  "content-#{o}",
                   topic_id: @topic[m].id,
                   user_id: @user.id)
      @topic[m].update_columns(last_post_id: @post[o].id)
    end
    @post.clear
  end
  @topic.clear
end

Forum.create!(title:  "Empty Forum")

