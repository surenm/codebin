ActiveAdmin.register GameType do
  permit_params :name, :engine_image, :allowed_player_images, :rules
end
