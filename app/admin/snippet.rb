ActiveAdmin.register Snippet do
  permit_params :user_id, :game_id, :code, :status, :input, :output, :error, :name, :language

  form do |f|
    f.inputs 'Belongs to' do
      f.input :name
      f.input :user_id, as: :select, collection: User.all
      f.input :game_id, as: :select, collection: Game.all
    end

    f.inputs 'Details' do
      f.input :code, as: :text
      f.input :language, as: :select, collection: Snippet::AVAILABLE_LANGUAGES.map {|lang, attr| lang }
      f.input :status, as: :select, collection: Snippet::available_statuses
      f.input :input, as: :text
    end

    f.actions
  end

end
