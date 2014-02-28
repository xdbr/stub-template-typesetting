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
def copy_project name='', template='', dest=''
  puts "File.exists?(dest) #{File.exists?(dest)}" ### ????
  if File.exists?(dest)
    puts "Project already exists at #{dest} and would be overwritten! Abort."
    exit 2
  else
    # Dir.mkdir dest # gah! no mkdir -p...
    sh "mkdir -p #{dest}" do |ok, err|
      if !ok
        puts "err: err"
        exit 3
      end
    end
  end
  puts "copying project '#{name}' from template/ to '#{dest}'" if DEBUG

  cmd = "cp -r template/#{template}/ #{dest}"
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
    args.each do |key|
      puts "check key: #{key}"
      unless args[key]
        puts "Argument '#{key}' required!" if DEBUG
        exit 1
      end
    end
  end
end

def checker proj, args
  require "JSON"
  res = JSON.load(File.new("#{proj}/project.json"))
  res['requires'].keys.each do |key|
    if ENV[key].nil?
      puts "Key: #{key} is required on the CLI"
      exit 42
    end
  end
  res
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
      :template => ENV['template'] || '.',
      :version => ENV['version'] || '.',
      :dest => ENV['dest'] || ENV['to'] || '.'
    )
    # Rake::Task['check:args'].invoke(ENV)
    checker :template, args
    check_args args, [:dest, :name, :template, :version]
    copy_project args.name, args.template, args.dest
    do_substitute args, args.dest, [:name, :template, :version]
  end

end # namespace