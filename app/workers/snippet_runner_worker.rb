class SnippetRunnerWorker
  @queue = :worker

  def self.perform(snippet_id)
    snippet = Snippet.find(snippet_id)

    snippet.status = Snippet::STATE_RUNNING
    snippet.save!

    if snippet.container.nil?
      container = Container.create image: "codebin/#{snippet.language}", snippet: snippet
    end
    snippet.container.execute

    snippet.status = Snippet::STATE_COMPLETED
    snippet.save!
  end
end