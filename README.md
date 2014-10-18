###Code Challenge

---

Example of use:

```ruby
job = Job.new("a=>j,b=>i,c=>h,d=>g,e=>f,f=>g,g=>a,h=>b,i=>e,j=>")
job.sort
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
f = File.read('test.txt')
job = Job.new(f)
job.sort
```