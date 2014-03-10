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

namespace 'template' do
  desc 'Get info about a project'
  task :info do |t|
    require 'JSON'

    # project = JSON.load(File.new("./template/#{ENV['template']}/project.json"))
    is_local = File.exists?("template/#{ENV['template']}")
    project = {}
    if is_local
      project = JSON.load(File.new("./template/#{ENV['template']}/project.json"))
    else
      template = %x: git clone #{ENV['template']} ./template/.store/#{ENV['template']} 2>/dev/null 1>/dev/null:
      # save this to some tmp/ dir first and delete afterwards if necessary
      project = JSON.load(File.new("./template/.store/#{ENV['template']}/project.json"))
    end

    puts project.info
  end

  desc 'Stub out new poject or class'
  task :new do |t|
    die "argument template=PROJECTNAME required! Abort.", 99 unless ENV.to_hash.minimum? ['template', 'to']

    require 'JSON'

    is_local = File.exists?("template/#{ENV['template']}")

    project = {}
    if is_local
      project = JSON.load(File.new("./template/#{ENV['template']}/project.json"))
    else
      die "A project already exists at '#{ENV['to']}'!\nPlease remove the directory and start again.", 12 if File.exists?("#{ENV['to']}")
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
  die "Project already exists at #{dest} \
       and would be overwritten! Abort.", 2 if File.exists?(dest)

  FileUtils.mkdir_p dest
  FileUtils.cp_r Dir.glob("template/#{template}/*"), dest
end


def do_substitute args, dest, subs=[]
  puts "dest: #{dest}" if DEBUG
  puts "subs: #{subs}" if DEBUG

  ARGV.clear
  ARGF.inplace_mode = ''

  FileList["#{dest}/**/*"].each do |file|
    ARGV << file.to_s if File.file?(file)
  end

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