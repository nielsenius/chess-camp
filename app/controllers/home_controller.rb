class HomeController < ApplicationController
  def index
    @upcoming_camps = Camp.upcoming.active.chronological.paginate(:page => params[:page]).per_page(10)
  end
  
  def camp_summary
    @camp = Camp.find(params[:id])
    @description = @camp.curriculum.description
    @instructors = @camp.instructors.alphabetical.to_a
    @registrations = @camp.students.alphabetical.to_a
    @location = @camp.location
  end
  
  def about
  end

  def contact
  end

  def privacy
  end
  
end
