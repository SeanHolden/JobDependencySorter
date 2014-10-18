require './job'

input1 = "a=>,b=>c,c=>f,d=>a,e=>b,f=>" #<- valid
input2 = File.read('spec/test.txt')    #<- valid
input3 = "a=>,b=>c,c=>f,d=>a,e=>,f=>b" #<- circular dependency
input4 = "a=>b,b=>b,c=>"               #<- self dependency

job1 = Job.new(input1)
job2 = Job.new(input2)

puts "\nJob 1: Input -> #{input1} ; output -> #{job1.sort}"
puts "\nJob 2: Read from file. Input: \n#{input2}output -> #{job2.sort}"

begin
  puts "\nJob 3: Input -> #{input3}. Should contain circular dependency error pointing out which items are circular:"
  job3 = Job.new(input3)
rescue CircularDependency => e
  puts e
end

begin
  puts "\nJob 4: Input -> #{input4}. Should contain self dependency error:"
  job4 = Job.new(input4)
rescue SelfDependency => e
  puts e
end