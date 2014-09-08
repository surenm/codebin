# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready () ->
  console.log("hello world")
  window.codeMirror = CodeMirror.fromTextArea($("#snippet-area").get(0), {
    value: "function myScript(){return 100;}\n"
    mode:  "ruby"
    lineNumbers: true
    autofocus: true
  });