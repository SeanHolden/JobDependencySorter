class Job

  def initialize(input='')
    error_message unless check(input) == 'valid'
    self.unsorted_string = input
  end

  def sort
    jobs = unsorted_string.split(',')
    output = []
    jobs.each do |job|
      split_job = job.split('=>')
      left = split_job[0].strip
      right = split_job[1].nil? ? nil : split_job[1].strip
      if right.nil?
        output << left
      end
    end
    output
  end

  private

  def unsorted_string=(input)
    @unsorted_string ||= input
  end

  def unsorted_string
    @unsorted_string
  end

  def check(input)
    if !input.kind_of? String
      @input_invalid = "Error: Input must be a comma separated string."
    elsif input.empty?
      @input_invalid = "Error: An argument must be entered."
    else
      "valid"
    end
  end

  def error_message  
    raise ArgumentError.new, @input_invalid
  end

end

