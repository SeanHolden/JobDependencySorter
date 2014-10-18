###Code Challenge

---

Example of use:

```ruby
require './job'

job = Job.new("a=>j,b=>i,c=>h,d=>g,e=>f,f=>g,g=>a,h=>b,i=>e,j=>")
puts job.sort
```

Output

```ruby
["j","a","g","f","e","i","b","h","c","d"]
```


####Alternatively (for same result)

```
# test.txt
a => j
b => i
c => h
d => g
e => f
f => g
g => a
h => b
i => e
j =>
```

```ruby
require './job'

f = File.read('test.txt')
job = Job.new(f)
puts job.sort
```

---

Run `example.rb` to see a quick example of how it works.