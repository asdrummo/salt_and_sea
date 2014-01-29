class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :store_location, :current_cart
  
    def store_location
      unless params[:controller] == "devise/sessions"
        url = #calculate the url here based on a params[:token] which you passed in
        session[:user_return_to] = url
      end
    end
    
    def send_registration_emails
      super
      UserMailer.welcome_email(@user).deliver unless @user.invalid?
      UserMailer.new_user_notification(@user).deliver unless @user.invalid?    
    end
    
    def stored_location_for(resource_or_scope)
      session[:user_return_to] || super
    end

    def after_sign_in_path_for(resource) unless user_signed_in?
      if (URI(request.referer).path == '/users/sign_in') 
        root_path 
      elsif (URI(request.referer).path == '/users/sign_up')
        root_path
      elsif (URI(request.referer).path == '/users/password/edit')
        root_path
      elsif (URI(request.referer).path == '/checkout')
        request.referer
      end
    end
    root_path
    end
    
    def after_sign_up_path_for(resource)
      if (URI(request.referer).path == '/users/sign_up')
        root_path
      else (URI(request.referer).path == '/checkout')
        request.referer
      end
    end
    
    def check_date(location)
      
      adjusted_date = (Date.today + 1.week)
      @next_date = Date.commercial(adjusted_date.year, adjusted_date.cweek, day_to_int(location.day))      
      
      time_to_merge = location.start_time 
      date_to_merge = @next_date
      @within_five_days = false
      @merged_datetime = DateTime.new(date_to_merge.year, date_to_merge.month, date_to_merge.day, time_to_merge.hour, time_to_merge.min, time_to_merge.sec, Rational(-4, 24))
      if DateTime.now.in_time_zone("Eastern Time (US & Canada)") < (@merged_datetime - 7.days)
        @next_date = (@merged_datetime - 7.days)
        @within_five_days = true
      end
      if DateTime.now.in_time_zone("Eastern Time (US & Canada)") > (@merged_datetime - 5.days)
        @within_five_days = true
      end
    end
    
    def current_cart
      if session[:paypal_params].nil?
      end
      if session[:cart_id]
        @current_cart ||= Cart.find(session[:cart_id])
        session[:cart_id] = nil if @current_cart.purchased_at
      end
      if session[:cart_id].nil?
        @current_cart = Cart.create!
        session[:cart_id] = @current_cart.id
      end
      @current_cart
      @cart = @current_cart
    end
    
    def find_customer
      @user = current_user
      @drop_locations = DropLocation.all
      @customer_drop_location = DropLocation.find_by_id(1)
      if user_signed_in? && Customer.find_by_user_id(current_user.id)
         @customer = Customer.find_by_user_id(current_user.id)
         @customer_drop_location = DropLocation.find(@customer.drop_location_id)
      end
    end
    
    def check_active(customer)
      @active = false
      customer.credits.each do |credit|
        if credit.credits_available >= 1
          @active = true
        end
      end
    end
    
    unless Rails.application.config.consider_all_requests_local
      rescue_from Exception, with: lambda { |exception| render_error 500, exception }
      rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
    end
    
    def day_to_int(day)
      if day == "0"
        return 7
      else
        return day.to_i
      end
    end
    
      
      def check_week(location, date, all_processed)
        date = Date.parse(date)
        location = DropLocation.find_by_id(location)
        if (location.processed == true) && (all_processed == false)
          week = (date + 1.week).cweek
          if week == 53
            week = 1
          end
        else
          week = date.cweek
        end

          if week.even? == true
            session[:week] = "even"
          else
            session[:week] = "odd"
          end
        end
          
          
          
    
    private
        
    def render_error(status, exception)
      ExceptionNotifier::Notifier.exception_notification(request.env, exception,
      :data => {:message => "was doing something wrong"}).deliver
      respond_to do |format|
        format.html { render template: "errors/error_#{status}", layout: 'layouts/application', status: status }
        format.all { render nothing: true, status: status }
      end
    end

    
    def authenticate_admin
        unless user_signed_in? && (current_user.admin == "admin") 
          redirect_to(:controller => 'home', :action => 'index')
        end
    end
  
end
