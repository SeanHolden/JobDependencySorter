class Job

  def initialize(input='')
    error_message unless check(input) == 'valid'
    self.unsorted_string = input
  end


  def sort
    jobs = unsorted_string.split(',')
    sorted_jobs, job_pairs = [],[],[]
    jobs.each do |job|
      job_split = job.split('=>')
      left,right = job_split[0],job_split[1]
      left = left.strip
      sorted_jobs << left
      unless right.nil?
        right = right.strip 
        job_pairs << [left,right]
      end
    end
    job_pairs.each do |job|
      left = job[0]
      right = job[1]
      if sorted_jobs.index(right) > sorted_jobs.index(left)
        sorted_jobs.delete(right)
        sorted_jobs.insert(sorted_jobs.index(left),right)
      end
    end

    sorted_jobs
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
