class SnippetView extends Backbone.View
  el: ".codebin-area"
  events:
    "change #snippet_language": 'language_changed_handler'

  initialize: () ->
    @snippet_el = $("#snippet-area")
    @output_el = $(@el).find(".output-area")
    @lang_el = $("#snippet_language")
    @editor = CodeMirror.fromTextArea(@snippet_el.get(0), {
      value: "function myScript(){return 100;}\n"
      mode: @lang_el.val()
      tabMode: "spaces"
      enterMode: "keep"
      lineNumbers: true
      autofocus: true
    })

    if @model?
      status = @model.get('status')
      if not status? || (status != "completed" && status != "failed")
        $.blockUI({ message: '<h1>Running your code...</h1><img src="/assets/loading.gif" /><br><br>' });
        @render()


  render: () ->
    setTimeout( () ->
      console.log "reloading..."
      window.location.reload()
    , 2500
    )

    return

  language_changed_handler: () ->
    @editor.setOption("mode", @lang_el.val());

  showLoading: () ->
    console.log "Show loading button..."

class SnippetModel extends Backbone.Model
  url: () ->
    "/snippets/#{@get('id')}"

  initialize: () ->
    @fetch()

  hasCompleted: () ->
    @get('status') == "completed"

$(document).ready () ->
  if window.snippet_data?
    model = new SnippetModel(snippet_data)
    console.log model
    new SnippetView({model: model})
  else
    new SnippetView()