require 'fileutils'
require 'timeout'

class Container < ActiveRecord::Base
  belongs_to :snippet
  RUN_VOLUMES_ROOT = File.join "/mnt", "codebin"

  def host_dir_path
    File.join Container::RUN_VOLUMES_ROOT, "#{id}"
  end

  def host_file_path(snippet_file_name)
    File.join host_dir_path, snippet_file_name
  end

  def docker_dir_path
    File.join "/", "codebin"
  end

  def docker_file_path(snippet_file_name)
    File.join docker_dir_path, snippet_file_name
  end

  def input_file_path
    File.join(host_dir_path, "stdin")
  end

  def output_file_path
    File.join(host_dir_path, "stdout")
  end

  def error_file_path
    File.join(host_dir_path, "stderr")
  end

  def input
    File.read(input_file_path)
  end

  def output
    File.read(output_file_path)
  end

  def error
    File.read(error_file_path)
  end

  def create_host_file(file_name, code)
    FileUtils.mkdir_p host_dir_path if not Dir.exists? host_dir_path
    File.write host_file_path(file_name), code
  end

  def create_files
    create_host_file("code.#{snippet.extension}", snippet.code)
    FileUtils.touch input_file_path
    FileUtils.touch output_file_path
    FileUtils.touch error_file_path
  end

  def docker_container
    Docker::Container.get(container_id)
  end

  def default_run_list
    ['/bin/run', snippet.executable, docker_file_path("code.#{snippet.extension}")]
  end

  def create_docker_container(run_list = nil)
    if run_list.nil?
      run_list = default_run_list
    end

    _container = Docker::Container.create(
      Image: "codebin/#{snippet.language}",
      Cmd: run_list,
      OpenStdin: true,
      StdinOnce: true
    )

    self.container_id = _container.id
    self.save!
  end

  def run_docker_container
    output, error = docker_container.tap {|c| c.start({Binds: ["#{host_dir_path}:/#{docker_dir_path}"]})}.attach(stdin: StringIO.new(input))

    File.write(output_file_path, output.join)
    File.write(error_file_path, error.join)
    snippet.output = output.join
    snippet.error = error.join
    snippet.save!
  end

  def destroy_docker_container!
    sleep 1.seconds
    docker_container.delete force: true
  end

  def execute
    puts "Creating Files..."
    create_files

    puts "Creating docker container..."
    create_docker_container

    puts "Running docker container..."
    run_docker_container

    puts "Finishing up..."
    destroy_docker_container!

    puts "Done."
  end
end