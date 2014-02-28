#
# globals
#

DEBUG = ENV['DEBUG'] || 0

#
# default task
#
task :default => [ 'new:project', :copy ]


#
# functions that are available to tasks
#
def copy_project name='', dest=''
  puts "copying project '#{name}' from template/ to '#{dest}'" if DEBUG
  cmd = "cp -r template/proj #{dest}"
  sh cmd do |ok, err|
    puts err if err
    puts "ok" if ok
  end
end

def check_args args, keys
  keys.each do |key|
    unless args[key]
      puts "Argument '#{key}' required!" if DEBUG
      exit 1
    end
  end
end

def do_substitute args, dest, subs=[]
  puts "dest: #{dest}" if DEBUG
  puts "subs: #{subs}" if DEBUG
  FileList["#{dest}/**/*.*"].each do |file|     # this Filelist will only match files which include a dot / have and extension!
    subs.each do |sub|
      puts "file: #{file}" if DEBUG
      puts "sub: #{sub} -> #{args[sub]}" if DEBUG
      cmd = "perl -i -pe 's<\\{\\{#{sub}\\}\\}><#{args[sub]}>go' #{file}"
      sh cmd do |ok, err|
        puts err if err
        puts "ok" if ok and DEBUG
      end
    end
  end
end

namespace 'check' do
  
  task :args, [:args] do |t, args|
    keys.each do |key|
      unless args[key]
        puts "Argument '#{key}' required!" if DEBUG
        exit 1
      end
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
    puts "Stubbing out new project" if DEBUG
    args.with_defaults(
      :name => ENV['name'] || '',
      :dest => ENV['dest'] || ENV['to'] || '.'
    )
    check_args args, [:dest, :name]
    copy_project args.name, args.dest
    do_substitute args, args.dest, [:name]
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
