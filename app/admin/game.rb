ActiveAdmin.register Game do
  permit_params :game_type_id, :status, :log, :player_a_id, :player_b_id,
    snippet_engine_attributes: [:id, :name, :language, :code, :input],
    snippet_b_attributes: [:id, :name, :language, :code, :input],
    snippet_a_attributes: [:id, :name, :language, :code, :input]

  controller do
    @game = Game.new
  end

  form do |f|
    f.inputs 'Player A' do
      f.input :player_a
      f.input :player_b
    end

    f.inputs 'Snippet for Engine', :for => [:snippet_engine, f.object.snippet_engine || Snippet.new ] do |se|
      se.input :code, as: :text
      se.input :language
    end

    f.inputs 'Snippet for Player a', :for => [:snippet_a, f.object.snippet_a || Snippet.new ] do |se|
      se.input :code, as: :text
      se.input :language
    end

    f.inputs 'Snippet for Player b', :for => [:snippet_b, f.object.snippet_b || Snippet.new ] do |se|
      se.input :code, as: :text
      se.input :language
    end

    f.inputs 'Miscellaneous' do
      f.input :game_type
      f.input :status, as: :select, collection: Game::available_game_statuses
    end
    f.actions
  end
end
