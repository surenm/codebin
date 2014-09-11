require 'fileutils'
require 'timeout'

class Container < ActiveRecord::Base
  belongs_to :snippet
  RUN_VOLUMES_ROOT = File.join "/tmp", "run"

  def host_path_for_volume
    File.join Container::RUN_VOLUMES_ROOT, "#{id}"
  end

  def setup_host_volume
    FileUtils.mkdir_p(host_path_for_volume)
  end

  def snippet_host_file_path
    File.join host_path_for_volume, "code.#{snippet.extension}"
  end

  def snippet_file_path
    File.join "/run", "code.#{snippet.extension}"
  end

  def input_file_path
    File.join(host_path_for_volume, "stdin")
  end

  def output_file_path
    File.join(host_path_for_volume, "stdout")
  end

  def error_file_path
    File.join(host_path_for_volume, "stderr")
  end

  def create_snippet_file
    setup_host_volume()
    File.write snippet_host_file_path, snippet.code
  end

  def create_io_files
    FileUtils.touch input_file_path
    FileUtils.touch output_file_path
    FileUtils.touch error_file_path
  end

  def container
    Docker::Container.get(container_id)
  end

  def create
    create_snippet_file()
    create_io_files()

    docker_container = Docker::Container.create(
      Image: image,
      Cmd: "ls -la",
      HostConfig: {
        Binds: ["#{host_path_for_volume}:/code"]
      }
    )

    self.container_id = docker_container.id
    self.save!
  end

  def run
    output, error = container.tap(&:start).attach(stdin: StringIO.new(input))
    File.write(output_file_path, output.join)
    File.write(error_file_path, error.join)
    destroy!
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

  def destroy!
    container.delete force: true
  end
end