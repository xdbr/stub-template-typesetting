DEBUG = ENV['DEBUG'] || false
VERBOSE = false

task :default => [ 'project:new' ]

namespace 'list' do

  desc 'List available templates'
  task :templates do
    FileList['template/*'].each do |tmpl|
      puts tmpl
    end
  end
end

namespace 'project' do
  desc 'Get info about a project'
  task :info do |t|
    require 'JSON'

    project = JSON.load(File.new("./template/#{ENV['template']}/project.json"))
    puts project.info
  end

  desc 'Stub out new poject'
  task :new do |t|
    die "argument template=PROJECTNAME required! Abort.", 99 unless ENV.to_hash.minimum? ['template', 'to']

    require 'JSON'

    is_local = File.exists?("template/#{ENV['template']}")
    puts is_local

    project = {}
    if is_local
      project = JSON.load(File.new("./template/#{ENV['template']}/project.json"))
    else
      template = %x: git clone #{ENV['template']} #{ENV['to']} :
      # save this to some tmp/ dir first and delete afterwards if necessary
      project = JSON.load(File.new("./#{ENV['to']}/project.json"))
    end
    project.check_required_args!
    project.check_optional_args!
    project.update!

    copy_project project['name'], project['template'], project['to'] if is_local
    do_substitute project, project['to'], project.keys
  end
end # namespace


# * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # *
# * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # *
# * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # * # *


#
# Helpers
#

class Hash
  def minimum?(keys_needed)
    keys_needed.each do |key|
      die "Key '#{key}' needed! Abort.", 7 if self[key].nil?
    end
  end

  def merge_env!
    merge_keys_from_env = [ 'to', 'template']
    merge_keys_from_env.each do |key|
      self[key] = ENV[key]
    end
  end

  def update!
    self.replace(self['requires'].merge self['optional'])
    self.merge_env!
  end

  def check_required_args!
    self['requires'].keys.each do |key|
      if ENV[key].nil?
        die "Required argument missing: #{key}", 66
      else
        self['requires'][key] = ENV[key]
      end
    end
  end

  def check_optional_args!
    self['optional'].keys do |key|
      self[key] = ENV[key] || self['optional'][key]
    end
  end

  def info
    puts "Template: #{ENV['template']}"
    puts "Required keys:"
    self['requires'].each { |r| puts "\t#{r}" }

    puts "\nOptional keys:"
    self['optional'].each { |r| puts "\t#{r}" }
    ''
  end
end

#
# functions that are available to tasks
#
def copy_project name='', template='', dest=''
  # puts "File.exists?(dest) #{File.exists?(dest)}" if DEBUG            ### ????
  die "Project already exists at #{dest} \
       and would be overwritten! Abort.", 2 if File.exists?(dest)

  # Dir.mkdir dest # gah! no mkdir -p...
  verbose(VERBOSE) do
    sh "mkdir -p #{dest}" do |ok, err|
      die "err: err", 3 if !ok
    end
  end
  # end

  puts "copying project '#{name}' from template/ to '#{dest}'" if DEBUG

  cmd = "cp -r template/#{template}/ #{dest}"
  sh cmd do |ok, err|
    puts err if err
    puts "ok" if ok
  end
end


def do_substitute args, dest, subs=[]
  puts "dest: #{dest}" if DEBUG
  puts "subs: #{subs}" if DEBUG

  ARGV.clear
  FileList["#{dest}/**/*.*"].each do |file|
    ARGV << file.to_s
  end
  
  ARGF.inplace_mode = ''
  ARGF.lines do |line|
    subs.each do |sub|
      line.gsub!("{{#{sub}}}", args[sub])
    end
    print line
  end
end

def die msg, code
  puts msg
  exit code
end

def x u
  puts "u: #{u}"
end


# namespace 'check' do
#   task :args, [:args] do |t, args|
#     args.each do |key|
#       puts "check key: #{key}"
#       unless args[key]
#         puts "Argument '#{key}' required!" if DEBUG
#         exit 1
#       end
#     end
#   end
# end

# def check_args args, keys
#   keys.each do |key|
#     unless args["#{key}"]
#       puts "Argument '#{key}' required!" if DEBUG
#       exit 1
#     end
#   end
# end

# def checker proj, args
#   require "JSON"
#   res = JSON.load(File.new("#{proj}/project.json"))
#   # res['requires'].keys.each do |key|
#   #   if ENV[key].nil?
#   #     puts "Key: #{key} is required on the CLI"
#   #     exit 42
#   #   end
#   # end
#   # res
#   res['requires'].keys
# end

