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

  language_changed_handler: () ->
    @editor.setOption("mode", @lang_el.val());

class SnippetModel extends Backbone.Model
  url: () ->
    "/snippets/#{@get('id')}"

  initialize: () ->
    @fetch()

  hasCompleted: () ->
    @get('status') == "completed"

$(document).ready () ->
  new SnippetView()