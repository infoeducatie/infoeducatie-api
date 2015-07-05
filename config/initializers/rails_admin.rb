require Rails.root.join('lib', 'rails_admin_approve_project.rb')
require Rails.root.join('lib', 'rails_admin_pin_news.rb')

RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end

  config.current_user_method(&:current_user)

  config.authorize_with do |controller|
    redirect_to main_app.root_path unless current_user.admin?
  end

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new do
      except ["UnapprovedProject", "Ckeditor::Asset", "Ckeditor::AttachmentFile", "Ckeditor::Picture"]
    end
    export do
      except ["Screenshot", "Ckeditor::Asset", "Ckeditor::AttachmentFile", "Ckeditor::Picture"]
    end
    bulk_delete
    show do
      except ["Ckeditor::Asset", "Ckeditor::AttachmentFile", "Ckeditor::Picture"]
    end
    edit do
      except ["Ckeditor::Asset", "Ckeditor::AttachmentFile", "Ckeditor::Picture"]
    end
    delete do
      except ["Project", "FinishedProject", "UnapprovedProject"]
    end
    show_in_app

    approve_project do
      only ['UnapprovedProject']
    end

    pin_news do
      only ['News']
    end


    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.included_models = ["FinishedProject", "UnapprovedProject", "Contestant", "User",
                            "Screenshot", "Edition", "News", "Ckeditor::Asset",
                            "Ckeditor::AttachmentFile", "Ckeditor::Picture", "Talk",
                            "Alumnus"]
end
