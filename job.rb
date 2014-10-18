require './validations'
include Validations::CustomErrors

class Job
  include Validations

  # Ensure all exceptions are handled before any other methods can
  # be called
  def initialize(input='')
    @unsorted_string = input
    validate_input
    format_string
    validate_self_and_circle_dependencies
  end

  # Sorts the list into the correct order using the rules that
  # are input by the user.
  def sort
    until order_is_valid? do
      @dependency_rules.each do |job|
        left, right = job[0], job[1]
        if @sorted_jobs.index(right) > @sorted_jobs.index(left)
          @sorted_jobs.delete(right)
          @sorted_jobs.insert(@sorted_jobs.index(left),right)
        end
      end
    end
    @sorted_jobs
  end

  private

  # Take the input string and format into processable arrays.
  def format_string
    jobs = @unsorted_string.split(',')
    @sorted_jobs, @dependency_rules = [],[]
    jobs.each do |job|
      job_split = job.split('=>')
      left,right = job_split[0],job_split[1]
      left = left.strip
      @sorted_jobs << left
      unless right.nil?
        right = right.strip 
        @dependency_rules << [left,right]
      end
    end
  end

end
