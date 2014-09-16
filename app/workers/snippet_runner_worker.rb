class SnippetRunnerWorker
  @queue = :worker

  def self.perform(snippet_id)
    snippet = Snippet.find(snippet_id)
    if snippet.container.nil?
      container = Container.create image: "codebin/#{snippet.language}", snippet: snippet
    end
    snippet.container.execute
  end
end