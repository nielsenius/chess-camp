class Ability
  include CanCan::Ability
  
  def initialize(user)
    # set user to new User if not logged in
    user ||= User.new # i.e., a guest user
    
    # set authorizations for different user roles
    if user.role? :admin
      # they get to do it all
      can :manage, :all
      
    elsif user.role? :instructor
      # can view their own details
      can :show, Instructor do |i|
        i.id == user.instructor.id
      end
      
      # can see lists of students in their camps
      can :read, Student do |s|
        camp_students = user.instructor.camps.students.map(&:id)
        camp_students.include? s.id
      end
      
      # can their edit info, except role
      can :update, Instructor do |i|
        i.id == user.instructor.id
      end
      cannot :update, User, [:role]
      
    else
      # can read home pages
      # can :read, Home
      
      # can read active, upcoming camps
      can :read, Camp do |c|
        c.active #&& Camp.upcoming.map(&:id).include? c.id
      end
      
      # can read address and map of camps
      can :read, Location
      # cannot :read, Location, [:max_capacity]
      
      # can read camp instructors' bios and photos
      can :read, Instructor, [:first_name, :last_name, :bio, :picture]
      can :read, Instructor do |i|
        Camp.upcoming.instructors.map(&:id).include? i.id
      end
      
    end
  end
end
