class Game < ActiveRecord::Base
  belongs_to :player_a, class_name: "User"
  belongs_to :player_b, class_name: "User"
  has_many :snippets
  belongs_to :game_type

  STATUS_WAITING = :waiting
  STATUS_QUEUED = :queued
  STATUS_RUNNING = :running
  STATUS_COMPLETED = :completed

  def self.available_game_statuses
    [STATUS_WAITING, STATUS_QUEUED, STATUS_RUNNING, STATUS_COMPLETED]
  end

  def snippet_name()
    "#{game_type.name}-#{player_a.name}-#{player_b.name}-#{id}"
  end

  def snippet_engine
    self.snippets.where(user: nil).first
  end

  def snippet_a
    self.snippets.where(user: player_a).first
  end

  def snippet_b
    self.snippets.where(user: player_b).first
  end

  def ready?
    snippet_a.present? && snippet_b.present?
  end

  def name
    "Game #{id} - #{player_a.name} & #{player_b.name}"
  end

  def game_code_path
    "#{Container::RUN_VOLUMES_ROOT}/#{game_type.name.upcase}"
  end

  def checkout_game_code
    puts self.game_type.engine_code_github
    if Dir.exists? game_code_path
      `cd #{game_code_path} && git fetch origin && git reset --hard origin/master`
    else
      `git clone #{game_type.engine_code_github} #{game_code_path}`
    end
  end

  def copy_game_files(snippet, subdirectory_path)
    if snippet.container.nil?
      Container.create! image: "codebin/#{game_type.allowed_player_images}", snippet: snippet
    end

    files = Dir["#{subdirectory_path}/**/*"]
    files.each do |file|
      next if File.directory? file
      file_name = Pathname.new(file).relative_path_from(Pathname.new subdirectory_path)
      contents = File.read file
      snippet.container.create_host_file(file_name, contents)
    end
  end

  def create_files_for_snippet(snippet)
    # Copy all code needed to run player container
    copy_game_files(snippet, "#{game_code_path}/player")

    # Create user submitted code in container
    snippet.container.create_host_file("player.#{snippet.extension}", snippet.code)
    snippet.container.create_host_file("orders.txt", ())
    snippet.container.create_host_file("state.txt", ())
    snippet.container.create_io_files()
  end

  def create_files_for_engine()
    if snippet_engine.nil?
      Snippet.create! name: snippet_name, language: :python, game: self
    end

    copy_game_files(snippet_engine, "#{game_code_path}/hexgame")
    snippet_engine.container.create_io_files
  end

  def player_run_list(snippet)
    ['/bin/run', snippet.executable, snippet.container.docker_file_path("player.#{snippet.extension}"), snippet.container.docker_file_path("state.txt"), snippet.container.docker_file_path("orders.txt")]
  end

  def engine_run_list
    ['/bin/run', 
      snippet_engine.executable,
      snippet_engine.container.docker_file_path("connector.#{snippet_engine.extension}"),
      '--a_ord',
      '/player_a/orders.txt',
      '--b_ord',
      '/player_b/orders.txt',
      '--a_state',
      '/player_a/state.txt',
      '--b_state',
      '/player_b/state.txt',
    ]
  end

  def create_files
    return if not ready?

    checkout_game_code

    create_files_for_snippet(snippet_a)
    create_files_for_snippet(snippet_b)

    create_files_for_engine()
  end

  def create_docker_containers
    snippet_a.container.create_docker_container(player_run_list(snippet_a))
    snippet_b.container.create_docker_container(player_run_list(snippet_b))

    snippet_engine.container.create_docker_container(engine_run_list)
  end

  def run_docker_containers
    container_threads = Array.new
    container_threads << Thread.new { snippet_a.container.run_docker_container }
    container_threads << Thread.new { snippet_b.container.run_docker_container }


    engine_extra_mount_binds = [
      {host_path: snippet_a.container.host_dir_path, docker_path: "/player_a" },
      {host_path: snippet_b.container.host_dir_path, docker_path: "/player_b" },
    ]

    container_threads << Thread.new { snippet_engine.container.run_docker_container(engine_extra_mount_binds) }

    container_threads.each { |thread| thread.join }
  end

  def destroy_docker_containers!
    snippet_a.container.destroy_docker_container!
    snippet_b.container.destroy_docker_container!
    snippet_engine.container.destroy_docker_container!
  end
end