class UserMailer < ActionMailer::Base
    default :from => "justine@saltandsea.me"

    def welcome_email(user)
      @user = user  
      @account = (root_url + "home/my_account" )
      attachments["banner_marketplace.jpg"] = File.read("#{Rails.root}/app/assets/images/banner_marketplace.jpg")
      mail(:to => "<#{user.email}>", :subject => "Welcome to Salt + Sea")
    end
    
    def new_user_notification(user)
      mail(:to => "justinecsimon@gmail.com", :subject => "new user: <#{user.email}> ")
    end
  end