# test-forum
#--------------
 
# a running version of this forum can be seen at https://powerful-thicket-7522.herokuapp.com/

#Installation Instructions
#--------------
#Install RVM (Ruby Version Manager):
#instructions here: https://rvm.io/
#if the 'gpg –keyserver' command fails, it may be necessary to use the following command instead: 'curl -sSL https://rvm.io/mpapis.asc | gpg --import -'

#Install Ruby and Rails:
#'rvm install 2.2.1' (for Ruby)
#'gem install rails -v 4.2.2'

#Install and configure Postgresql:
#'sudo apt-get install postgresql-9.3 postgresql-contrib-9.3 libpq-dev'
#'sudo -u postgres createuser -s pguser'
#'sudo -u postgres psql'
#create a password for pguser: 'alter user pguser with password 'password';'

#Install and configure Git:
#'sudo apt-get install git'
#'git config --global user.name "Your Name"'
#'git config --global user.email "Your Email"'
#'git config --global push.default matching'

#Get the source code:
#'git clone https://github.com/andrewmurray21/test-forum test-forum'

#Setting up the environment (within test-forum folder):
#install gems: 'bundle install –without production'
#create DBs: 'bundle exec rake db:create'
#add migrations: 'bundle exec rake db:migrate'
#add test data: 'bundle exec rake db:seed'

#Start the server
#'rails server'

#If you wish to log in with the admin user, you can use the following credentials:
#Email: 'testforum63@gmail.com'
#Password: 'password'
