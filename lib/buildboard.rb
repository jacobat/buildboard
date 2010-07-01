require 'rubygems'
require 'sinatra'
require 'yaml'
require 'fileutils'

class Build < Struct.new(:sha, :started_at, :finished_at, :status, :output, :project, :path)
  class << self
    def load_file(filename)
      build_data = YAML::load_file(filename)
      new(build_data['sha'],
          Time.parse(build_data['started_at']),
          Time.parse(build_data['finished_at']),
          build_data['status'],
          build_data['output'],
          build_data['project'],
          filename)
    end
  end
  
  def css_class
    status
  end
  
  def file
    File.basename(path)
  end
end

class Builder
  class << self
    def projects
      Dir[File.join(build_dir, '*')].map{|project|
        project_name = project.gsub("#{build_dir}/", '')
        last_build = Dir[File.join(project, '*')].last
        Build.load_file(last_build)
      }
    end

    def find(projectname, filename)
      Build.load_file(File.join(build_dir, projectname, filename))
    end

    def builds_for(projectname)
      Dir[File.join(build_dir, projectname, '*-*-*')].reverse[0..9].map{|build|
        Build.load_file(build)
      }
    end

    def builds
      Dir[File.join(build_dir, '**', '*-*-*')].map{|build|
        match = build.match(/.*\/(.*)-(.*)-(.*)/)
        { :started => Time.at(match[1].to_i),
          :sha => match[2],
          :status => match[3],
          :integrity_status => (match[3] == 'failure' ? 'failed' : 'success')
        }
      }
    end

    def build_dir
      'builds'
    end
  end

  def initialize(params)
    @params = params
  end

  def project_dir
    File.join(self.class.build_dir, @params[:project])
  end

  def build_file
    started = Time.parse(@params[:started_at]).to_i
    File.join(project_dir, "#{started}-#{@params[:sha][0..7]}-#{@params[:status]}")
  end
  
  def dump
    FileUtils.mkdir_p(project_dir)
    File.open(build_file, "w") do |file|
      YAML::dump(@params, file)
    end
  end
end

class Buildboard < Sinatra::Base
  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end
  
  set :public, File.dirname(__FILE__) + '/../public'
  
  get '/' do
    @builds = Builder.projects
    erb :index
  end

  get /\/(.*)\/(.*)/ do |projectname, sha|
    @build = Builder.find(projectname, sha)
    erb :build
  end

  get /\/(.*)/ do |projectname|
    @builds = Builder.builds_for(projectname)
    @projectname = projectname
    erb :project
  end
  
  post '/' do
    Builder.new(params).dump
    "Alrighty, Joe"
  end
end
