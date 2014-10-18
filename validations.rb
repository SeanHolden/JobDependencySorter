# This module is for all validations and error handling of the Job class.
module Validations

  private 
  
  # Some custom errors that are more meaningful than simply StandardError.
  module CustomErrors
    class CircularDependency < StandardError;end
    class UndeclaredJob < StandardError;end
    class SelfDependency < StandardError;end
  end

  # Checks if the current order of our job list satisfies all the dependencies.
  # Returns true or false.
  def order_is_valid?
    rules_passed = 0
    @dependency_rules.each do |pair|
      if @sorted_jobs.index(pair[1]) < @sorted_jobs.index(pair[0])
        rules_passed = rules_passed + 1
      end
    end
    rules_passed == @dependency_rules.length
  end

  # Checks that the input is in the correct format. (non empty, comma seperated string.)
  def validate_input
    if !@unsorted_string.kind_of? String
      raise ArgumentError.new, "Error: Input must be a comma separated string."
    elsif @unsorted_string.empty?
      raise ArgumentError.new, "Error: An argument must be entered."
    elsif !@unsorted_string.include? '=>'
      raise ArgumentError.new, "Error: input must contain '=>' symbols to indicate dependencies."
    end
  end

  # As the title suggests. Checks for circular dependencies and raises error if true.
  # How it works: for each "pair" of dependency rules, loop through all the dependency rules
  # and check if the one on the right appears anywhere on the left. If so check that one
  # in the same manner. Keep adding these to a list. If, in our list, the item on the right
  # appears on the left of another item... then it is a circular dependency.
  def validate_circular_dependencies
    @dependency_rules.each do |rule|
      right = rule[1]
      culprits=''
      @dependency_rules.each do |r|
        appears_on_left = r[0]
        if right == appears_on_left
          right = r[1]
          culprits+="#{r[0]}=>#{r[1]};"
        end
        if culprits.include?("=>#{right}") && culprits.include?("#{right}=>")
          raise CircularDependency.new, "Error: Jobs can’t have circular dependencies. (#{culprits})"
        end
      end
    end
  end

  # Checking that left hand side value does not equal right hand side value.
  def validate_self_dependencies
    @dependency_rules.each do |rule|
      if rule[0] == rule[1]
        raise SelfDependency.new, "Error: Jobs can’t depend on themselves."
      elsif job_is_not_declared? rule[1]
        raise UndeclaredJob.new, "Error: All jobs must be declared on the left hand side."
      end
    end
  end

  # All jobs that appear on the right (dependent on another job) must appear on the left
  # at some point. E.g. [ a=>z,b=>a ] should not be valid as z is not "declared".
  def job_is_not_declared?(job)
    !@sorted_jobs.include? job
  end

end