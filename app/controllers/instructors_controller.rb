class InstructorsController < ApplicationController
  include ActionView::Helpers::NumberHelper
  
  before_action :set_instructor, only: [:show, :edit, :update, :destroy]
  
  authorize_resource

  def index
    @active_instructors = Instructor.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_instructors = Instructor.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @upcoming_camps = @instructor.camps.upcoming.chronological
    @past_camps = @instructor.camps.past.chronological
  end

  def new
    @instructor = Instructor.new
    @instructor.build_user
  end

  def edit
    # reformating the phone so it has dashes when displayed for editing (personal taste)
    @instructor.phone = number_to_phone(@instructor.phone)
    @instructor.build_user if @instructor.user.nil?
  end

  def create
    @instructor = Instructor.new(instructor_params)
    if @instructor.save
      redirect_to @instructor, notice: "#{@instructor.proper_name} was added to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @instructor.update(instructor_params)
      redirect_to @instructor, notice: "#{@instructor.proper_name} was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @instructor.destroy
    redirect_to instructors_url, notice: "#{@instructor.proper_name} was removed from the system."
  end

  private
    def set_instructor
      @instructor = Instructor.find(params[:id])
    end

    def instructor_params
      if current_user && current_user.role?(:admin)
        params.require(:instructor).permit(:first_name, :last_name, :bio, :email, :phone, :active, user_attributes: [:username, :password, :password_confirmation, :instructor_id, :role, :active])
      else
        params.require(:instructor).permit(:first_name, :last_name, :bio, :email, :phone, :active)
      end
    end
end
