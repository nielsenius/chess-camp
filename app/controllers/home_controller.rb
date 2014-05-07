class HomeController < ApplicationController
  def index
    @upcoming_camps = Camp.upcoming.active.chronological.paginate(:page => params[:page]).per_page(10)
  end
  
  def about
  end

  def contact
  end

  def privacy
  end
  
  def camp_summary
    @camp = Camp.find(params[:id])
    @description = @camp.curriculum.description
    @instructors = @camp.instructors.active.alphabetical.to_a
    @registrations = @camp.students.alphabetical.to_a
    @location = @camp.location
  end
  
  def dashboard
    @instructor = current_user.instructor
    @my_upcoming_camps = @instructor.camps.active.upcoming.to_a
    
    if current_user.role == 'admin'
      @all_upcoming_camps = Camp.upcoming.active.chronological.paginate(:page => params[:page]).per_page(6)
    end
  end
  
end
