Dir[Rails.root.join('lib/admin/*.rb')].each { |f| require f }

RailsAdmin.config do |config|
  config.asset_source = :sprockets
  config.main_app_name = ["InfoEducație", "Admin"]
  config.show_gravatar = false
  config.compact_show_view = true
  config.default_items_per_page = 30

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end

  config.current_user_method(&:current_user)

  config.authorize_with do
    redirect_to main_app.root_path unless current_user&.admin?
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
      except ["ApiCredential", "RoboticsCompetition", "RoboticsTeam",
              "RoboticsTurn", "RoboticsTimeEntry", "Ckeditor::Asset",
              "Ckeditor::AttachmentFile", "Ckeditor::Picture", "ContentPage"]
    end
    export do
      except ["ApiCredential", "Screenshot", "RoboticsCompetition",
              "RoboticsTeam", "RoboticsTurn", "RoboticsTimeEntry",
              "Ckeditor::Asset", "Ckeditor::AttachmentFile",
              "Ckeditor::Picture"]
    end
    show do
      except ["Ckeditor::Asset", "Ckeditor::AttachmentFile", "Ckeditor::Picture"]
    end
    edit do
      except ["ApiCredential", "RoboticsTurn", "RoboticsTimeEntry",
              "Ckeditor::Asset", "Ckeditor::AttachmentFile",
              "Ckeditor::Picture"]
    end
    delete do
      except ["ApiCredential", "Project", "Contestant",
              "RoboticsCompetition", "RoboticsTeam", "RoboticsTurn",
              "RoboticsTimeEntry", "ContentPage"]
    end
    bulk_delete do
      except ["ApiCredential", "Project", "Contestant",
              "RoboticsCompetition", "RoboticsTeam", "RoboticsTurn",
              "RoboticsTimeEntry", "ContentPage"]
    end
    show_in_app do
      except ["ApiCredential", "RoboticsCompetition", "RoboticsTeam",
              "RoboticsTurn", "RoboticsTimeEntry", "SponsorTier", "Sponsor",
              "JuryCategory", "JuryMember", "JudgingCriterion", "PhotoAlbum",
              "ContentPage", "BlogPost"]
    end

    approve_project do
      only ['Project']
    end

    reject_project do
      only ['Project']
    end

    confirm_user do
      only ["User"]
    end

    pin_news do
      only ['News']
    end

    issue_api_credential do
      only ["ApiCredential"]
    end

    revoke_api_credential do
      only ["ApiCredential"]
    end

    create_robotics_competition do
      only ["RoboticsCompetition"]
    end

    adjust_robotics_team_time do
      only ["RoboticsTeam"]
    end

    regenerate_robotics_team_pin do
      only ["RoboticsTeam"]
    end

    force_stop_robotics_turn do
      only ["RoboticsTurn"]
    end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.navigation_static_label = "External tools"
  config.navigation_static_links = {
    "InfoEducație website" => Settings.ui.url,
    "Community admin" => "#{Settings.ui.community_url.to_s.delete_suffix("/")}/admin",
    "InfoEducație support" => "https://infoeducatie.zendesk.com/",
    "Ping support" => "https://ping.zendesk.com"
  }

  config.included_models = ["ApiCredential", "Project", "Contestant", "User", "Talk",
                            "Screenshot", "Edition", "News", "Ckeditor::Asset",
                            "Ckeditor::AttachmentFile", "Ckeditor::Picture",
                            "Alumnus", "SponsorTier", "Sponsor", "JuryCategory", "JuryMember",
                            "JudgingCriterion", "PhotoAlbum", "ContentPage", "BlogPost",
                            "Teacher", "RoboticsCompetition",
                            "RoboticsTeam", "RoboticsTurn",
                            "RoboticsTimeEntry"]

  {
    "Project" => ["Competition", "fas fa-laptop-code", 10],
    "Contestant" => ["Competition", "fas fa-user-graduate", 20],
    "Edition" => ["Competition", "fas fa-calendar-alt", 30],
    "Teacher" => ["Competition", "fas fa-chalkboard-teacher", 40],
    "Screenshot" => ["Competition", "fas fa-images", 50],
    "User" => ["Community", "fas fa-users", 60],
    "News" => ["Community", "fas fa-newspaper", 70],
    "Talk" => ["Community", "fas fa-microphone", 80],
    "Alumnus" => ["Community", "fas fa-user-check", 90],
    "SponsorTier" => ["Community", "fas fa-layer-group", 100],
    "Sponsor" => ["Community", "fas fa-handshake", 110],
    "JuryCategory" => ["Community", "fas fa-gavel", 120],
    "JuryMember" => ["Community", "fas fa-user-tie", 130],
    "JudgingCriterion" => ["Community", "fas fa-file-pdf", 140],
    "PhotoAlbum" => ["Community", "fas fa-images", 150],
    "ContentPage" => ["Community", "fas fa-file-alt", 160],
    "BlogPost" => ["Community", "fas fa-pen-nib", 170],
    "ApiCredential" => ["Security", "fas fa-key", 100],
    "Ckeditor::Asset" => ["Editor media", "fas fa-photo-video", 110],
    "Ckeditor::AttachmentFile" => ["Editor media", "fas fa-paperclip", 120],
    "Ckeditor::Picture" => ["Editor media", "fas fa-image", 130],
    "RoboticsCompetition" => ["Robotics", "fas fa-flag-checkered", 10],
    "RoboticsTeam" => ["Robotics", "fas fa-users", 20],
    "RoboticsTurn" => ["Robotics", "fas fa-stopwatch", 30],
    "RoboticsTimeEntry" => ["Robotics", "fas fa-clock", 40]
  }.each do |model_name, (nav_label, nav_icon, nav_weight)|
    config.model model_name do
      navigation_label nav_label
      navigation_icon nav_icon
      weight nav_weight
    end
  end
end
