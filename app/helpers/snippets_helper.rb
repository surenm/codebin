module SnippetsHelper

  def available_languages
    Snippet::AVAILABLE_LANGUAGES.map {|lang, lang_display_name| [lang_display_name, lang] }
  end
end
