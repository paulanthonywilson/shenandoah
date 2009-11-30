require 'spec/expectations'

Before do
  @original_wd = FileUtils.pwd
end

After do
  FileUtils.cd @original_wd
  if @pipe
    Process.kill 15, @pipe.pid
    @pipe.close
  end
  cleanup
end

class ShenandoahWorld
  include FileUtils

  def root_path
    @root ||= File.expand_path("../../..")
  end

  def base_project
    @base_project ||= File.expand_path("../example_projects/base", File.dirname(__FILE__))
  end

  def switch_to_project(name)
    path = File.expand_path("../#{name}", base_project);
    self.temp_projects << path
    mkdir_p path
    cd path
    path
  end

  def cleanup
    self.temp_projects.each { |dir| rm_rf dir }
  end

  protected

  def temp_projects
    @temp_projects ||= []
  end
end

World do
  ShenandoahWorld.new
end