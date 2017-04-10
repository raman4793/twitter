def seed_image(file_name)
  File.open(File.join(Rails.root, "/app/assets/images/#{file_name}"))
end

sexes = ['Male', 'Female']
males = ['1.jpg', '2.jpg', '4.jpg']
females = ['3.jpg', '5.jpg']

User.create!(name:  Faker::Name.name,
             uname: Faker::Name.first_name,
             email: "user@blogger.com",
             password:              "123456",
             password_confirmation: "123456",
             admin:     false,
             activated: true,
             sex: 'Male',
             dob: Faker::Date.backward(5000),
             country: Faker::Address.country,
             city: Faker::Address.city,
             state: Faker::Address.state,
             mobile: Faker::PhoneNumber.cell_phone,
             description: Faker::Lorem.paragraph(2),
             activated_at: Time.zone.now, dp: seed_image('1.jpg'))

99.times do |n|
  name  = Faker::Name.name
  email = "user-#{n+1}@blogger.com"
  password = "123456"
  uname = Faker::Name.first_name+n.to_s
  sex = sexes[rand(0..1)]
  puts("Sex = #{sex}")
  dob = Faker::Date.backward(5000)
  country = Faker::Address.country
  city = Faker::Address.city
  state = Faker::Address.state
  mobile = Faker::PhoneNumber.cell_phone
  description = Faker::Lorem.paragraph(2)
  if sex=='Male'
    dp = males[rand(0..2)]
  else
    dp = females[rand(0..1)]
  end
  puts("Dp = #{dp}")
  User.create!(name:  name,
               uname: uname,
               email: email,
               dob: dob,
               country: country,
               state: state,
               city: city,
               mobile: mobile,
               description: description,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now, dp: seed_image(dp))
end

puts('Created Users')

25.times do |i|
  Tag.create(name: Faker::Lorem.word)
end

puts('Created Tags')

# Microposts
users = User.order(:created_at).take(6)
50.times do
  content = '<p>' + Faker::Lorem.sentence(1)
  content.concat('#'.concat(Tag.find(rand(1..25)).name))
  content.concat(Faker::Lorem.sentence(1))
  content.concat('#'.concat(Tag.find(rand(1..25)).name))
  content.concat(' <span class="atwho-inserted">'.concat(User.find(rand(1..30)).uname).concat('</span>'))
  content= content+ '</p>'
  users.each { |user| user.microposts.create!(content: content) }
end

puts('Created Posts')

# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

AdminUser.create!(email: 'admin@μblogger.com', password: '123456', password_confirmation: '123456')

puts('Created Followings')
i=0
Micropost.first(50).each do |post|
  n = rand(10...100)
  users = User.first(n)
  users.each do |user|
    puts("Liking #{i}")
    post.likes.create(user: user)
    i = i+1
  end
end

puts('Created Likes')