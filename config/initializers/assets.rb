# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( pages.js )

# render haml templates from the assets folder
Rails.application.assets.register_engine('.haml', Tilt::HamlTemplate)

# ckeditor assets
Rails.application.config.assets.precompile += %w( ckeditor/* )
