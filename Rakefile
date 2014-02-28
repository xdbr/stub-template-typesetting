desc 'copy task'
task :copy do |t|
  exit "TO=X" unless ENV['TO']
  puts ENV['TO']
end

desc "Testing environment and variables"
task :hello, [:name]  do |t, args|
  args.with_defaults(:name => ENV['name'] || "world")
  puts "Hello #{args.name}"   # Q&A above had a typo here : #{:message}
end

task :default => [ :hello, :copy ]