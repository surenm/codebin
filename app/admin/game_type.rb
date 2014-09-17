ActiveAdmin.register GameType do
  permit_params :name, :engine_image, :engine_code_github, :allowed_player_images, :rules
end
