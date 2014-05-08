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
    @all_active_camps = Camp.active.alphabetical.to_a.map { |c| [c.name, c.id] }
    @all_active_families = Family.active.alphabetical.to_a.map { |f| [f.family_name, f.id] }
    
    if current_user.role == 'admin'
      @all_upcoming_camps = Camp.upcoming.active.chronological.paginate(:page => params[:page]).per_page(6)
    end
  end
  
  def report
    @type = params["/home/dashboard/report"][:type]
    if @type == "camp"
      @camp = Camp.find_by_id(params["/home/dashboard/report"][:camp])
      @paid = @camp.registrations.select { |r| r.payment_status == 'full' }.count * @camp.cost
      @owed = @camp.registrations.select { |r| r.payment_status == 'deposit' }.count * @camp.cost
    elsif @type == "family"
      @family = Family.find_by_id(params["/home/dashboard/report"][:family])
      @year = params["/home/dashboard/report"]["year(1i)"]
      @paid = 0
      @owed = 0
      @family.students.each do |student|
        student.registrations.each do |r|
          if r.payment_status == 'full'
            @paid += r.camp.cost
          else
            @paid += 50
            @owed += r.camp.cost - 50
          end
        end
      end
    else
      @camps = Camp.active.to_a
      @year = params["/home/dashboard/report"]["year(1i)"]
      @paid = 0
      @owed = 0
      Camp.active.to_a.each do |camp|
        camp.registrations.each do |r|
          if r.payment_status == 'full'
            @paid += r.camp.cost
          else
            @paid += 50
            @owed += r.camp.cost - 50
          end
        end
      end
    end
  end
  
end
