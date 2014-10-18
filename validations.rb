# This module is for all validations and error handling of the Job class.
module Validations

  private 

  # Checks that the input is in the correct format. (non empty, comma seperated string.)
  def validate_input
    if !@unsorted_string.kind_of? String
      raise ArgumentError.new, "Error: Input must be a comma separated string."
    elsif !@unsorted_string.empty? && !@unsorted_string.include?('=>')
      raise ArgumentError.new, "Error: input must contain '=>' symbols to indicate dependencies."
    end
  end

  # Perform all validations in a single loop.
  def validate_dependencies
    @dependency_rules.each do |rule|
      check_for_self_dependency(rule[0],rule[1])
      check_if_job_declared(rule[1])
      check_for_circular_dependency(rule)
    end
  end

  # Checks if the current order of our job list satisfies all the dependencies.
  def order_is_valid?
    rules_passed = 0
    @dependency_rules.each do |pair|
      if @sorted_jobs.index(pair[1]) < @sorted_jobs.index(pair[0])
        rules_passed = rules_passed + 1
      end
    end
    rules_passed == @dependency_rules.length
  end

  # Check for circular dependencies and raise error if true.
  # How it works: for each "pair" of dependency rules, loop through all the dependency rules
  # and find the item where the right hand side value to the item we have currently, appears on the left. 
  # Check that new item in the same manner. Keep adding these to a list. If, we get a repeat item in this list
  # then we have a circle dependency. We can display the culprits that caused the error in our error message.
  def check_for_circular_dependency(item,circle_check=[],culprits='')
    rules_hash = @dependency_rules.to_h
    if rules_hash[item[1]]
      left,right = item[1],rules_hash[item[1]]
      check_for_self_dependency(left,right)
      circle_check << [ left, right ]
      if circle_check.uniq.length != circle_check.length
        raise CircularDependency.new, "Error: Jobs can’t have circular dependencies. (#{culprits})"
      end
      culprits += "#{left}=>#{right};"
      # Down the rabbit hole we go... finding all the "culprits" that could cause us an error.
      check_for_circular_dependency([ left, right ], circle_check, culprits)
    end
  end

  def check_for_self_dependency(left,right)
    if left == right
      raise SelfDependency.new, "Error: Jobs can’t depend on themselves."
    end
  end

  # All jobs that appear on the right (dependent on another job) must appear on the left
  # at some point. E.g. [ a=>z,b=>a ] should not be valid as z is not "declared".
  def check_if_job_declared(job)
    if !@sorted_jobs.include? job
      raise UndeclaredJob.new, "Error: All jobs must be declared on the left hand side."
    end
  end

  # Some custom errors that are more meaningful than simply StandardError.
  module CustomErrors
    CircularDependency = Class.new StandardError
    UndeclaredJob = Class.new StandardError
    SelfDependency = Class.new StandardError
  end

end