# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.precompile += %w( pages.js )

# render haml templates from the assets folder
class TiltProcessor
  def initialize(klass)
    @klass = klass
  end

  def call(input)
    filename = input[:filename]
    data     = input[:data]
    context  = input[:environment].context_class.new(input)

    data = @klass.new(filename) { data }.render(context, {})
    context.metadata.merge(data: data.to_str)
  end
end

Rails.application.config.assets.configure do |env|
  env.register_mime_type 'text/html',  extensions: ['.haml']
  env.register_preprocessor 'text/html', TiltProcessor.new(Tilt::HamlTemplate)
end

# ckeditor assets
Rails.application.config.assets.precompile += %w( ckeditor/* )
