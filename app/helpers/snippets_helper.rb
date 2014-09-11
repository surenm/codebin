module SnippetsHelper

  def available_languages
    Snippet::AVAILABLE_LANGUAGES.map {|lang, lang_attributes| [lang_attributes[:display], lang] }
  end
end
