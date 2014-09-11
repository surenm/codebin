class SnippetRunnerWorker
  @queue = :worker

  def self.perform(snippet_id)
    snippet = Snippet.find(snippet_id)
    container = Container.create image: "codebin/#{snippet.language}", snippet: snippet
  end
end