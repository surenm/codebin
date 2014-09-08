json.array!(@snippets) do |snippet|
  json.extract! snippet, :id
  json.url snippet_url(snippet, format: :json)
end
