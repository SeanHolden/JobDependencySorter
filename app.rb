def sort_job_list(input='')
  return error_message unless input.kind_of? String
end

def error_message
  "Error: Input must be a comma separated string."
end

puts sort_job_list('a,b,c')