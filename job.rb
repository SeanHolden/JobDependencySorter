class Job

  def initialize(input='')
    @unsorted_string = input
    validate_input # check input is non empty string
    format_string # format into processible arrays 
    validate_self_dependencies
    validate_circular_dependencies
  end

  def sort
    until order_is_valid? do
      @dependency_rules.each do |job|
        left = job[0]
        right = job[1]
        if @sorted_jobs.index(right) > @sorted_jobs.index(left)
          @sorted_jobs.delete(right)
          @sorted_jobs.insert(@sorted_jobs.index(left),right)
        end
      end
    end
    @sorted_jobs
  end

  private

  def order_is_valid?
    rules_passed = 0
    @dependency_rules.each do |pair|
      # If right is before left, this rule passes.
      if @sorted_jobs.index(pair[1]) < @sorted_jobs.index(pair[0])
        rules_passed = rules_passed + 1
      end
    end
    rules_passed == @dependency_rules.length
  end

  def validate_input
    if !@unsorted_string.kind_of? String
      raise ArgumentError.new, "Error: Input must be a comma separated string."
    elsif @unsorted_string.empty?
      raise ArgumentError.new, "Error: An argument must be entered."
    end
  end

  def validate_self_dependencies
    @dependency_rules.each do |rule|
      if rule[0] == rule[1]
        raise StandardError.new, "Error: Jobs can’t depend on themselves."
      end
    end
  end

  def validate_circular_dependencies
  end

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

