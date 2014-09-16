class SnippetView extends Backbone.View
  el: ".codebin-area"

  initialize: () ->
    @snippet_el = $("#snippet-area")
    @output_el = $(@el).find(".output-area")
    window.codeMirror = CodeMirror.fromTextArea(@snippet_el.get(0), {
      value: "function myScript(){return 100;}\n"
      mode:  "ruby"
      lineNumbers: true
      autofocus: true
    })

class SnippetModel extends Backbone.Model
  url: () ->
    "/snippets/#{@get('id')}"

  initialize: () ->
    @fetch()

  hasCompleted: () ->
    @get('status') == "completed"

$(document).ready () ->
  new SnippetView()