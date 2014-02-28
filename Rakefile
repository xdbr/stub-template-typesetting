#
# default task
#
task :default => [ 'new:project', :copy ]


#
# functions that are available to tasks
#
def copy_project name='', dest=''
  puts "copying project '#{name}' from template/ to '#{dest}'"
end

def check_args args, keys
  keys.each do |key|
    unless args[key]
      puts "Argument '#{key}' required!"
      exit 1
    end
  end
end


#
# tasks are separated into namespaces
#
namespace 'new' do

  #
  # task 'project:new' with args 'name=FOO' and 'dest=BAR' (or 'to=BAR')
  #
  desc 'Stub out new poject'
  task :project, [:name, :dest] do |t, args|
    puts "Stubbing out new project"
    args.with_defaults(
      :name => ENV['name'] || '',
      :dest => ENV['dest'] || ENV['to'] || '.'
    )
    check_args args, [:dest, :name]
    copy_project args.name, args.dest
  end

end # namespace


# desc 'copy task'
# task :copy do |t|
#   exit "TO=X" unless ENV['TO']
#   puts ENV['TO']
# end
# 
# desc "Testing environment and variables"
# task :hello, [:name]  do |t, args|
#   args.with_defaults(:name => ENV['name'] || "world")
#   puts "Hello #{args.name}"
# end
# 
