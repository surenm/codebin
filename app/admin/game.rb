ActiveAdmin.register Game do
  permit_params :game_type_id, :status, :log, :player_a_id, :player_b_id

  form do |f|
    f.inputs 'Player A' do
      f.input :player_a
      f.input :player_b
    end

    f.inputs 'Miscellaneous' do
      f.input :game_type
      f.input :status, as: :select, collection: Game::available_game_statuses
    end
    f.actions
  end
end
