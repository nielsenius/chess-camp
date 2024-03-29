class CampsController < ApplicationController
  
  before_action :set_camp, only: [:show, :edit, :update, :destroy]
  
  authorize_resource

  def index
    @upcoming_camps = Camp.upcoming.active.chronological.paginate(:page => params[:page]).per_page(10)
    @past_camps = Camp.past.chronological.paginate(:page => params[:page]).per_page(10)
    @inactive_camps = Camp.inactive.alphabetical.to_a
  end

  def show
    @instructors = @camp.instructors.alphabetical.to_a
    @registrations = @camp.students.alphabetical.to_a
    @is_upcoming = Camp.upcoming.to_a.include? @camp
    
    @registration = Registration.new
    min_rating = @camp.curriculum.min_rating
    max_rating = @camp.curriculum.max_rating + 1
    @eligible_students = Student.active.below_rating(max_rating).at_or_above_rating(min_rating).alphabetical.to_a.map { |s| [s.name, s.id] }
  end

  def new
    @camp = Camp.new
  end

  def edit
  end

  def create
    @camp = Camp.new(camp_params)
    if @camp.save
      redirect_to @camp, notice: "The camp #{@camp.name} (on #{@camp.start_date.strftime('%m/%d/%y')}) was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @camp.update(camp_params)
      redirect_to @camp, notice: "The camp #{@camp.name} (on #{@camp.start_date.strftime('%m/%d/%y')}) was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @camp.destroy
    redirect_to camps_url, notice: "#{@camp.name} camp on #{@camp.start_date.strftime('%m/%d/%y')} was removed from the system."
  end

  private
    def set_camp
      @camp = Camp.find(params[:id])
    end

    def camp_params
      params.require(:camp).permit(:curriculum_id, :cost, :start_date, :end_date, :time_slot, :max_students, :active, :location_id, instructor_ids: [])
    end
end
