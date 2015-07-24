extends "v1/projects/base.rabl"
object @project

child :screenshots => :screenshots do
  attributes :url
end

attributes :description,
           :technical_description,
           :system_requirements,
           :source_url,
           :homepage
