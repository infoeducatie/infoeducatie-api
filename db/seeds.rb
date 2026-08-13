# Core records required by the application in every environment.
%w[registered contestant alumni speaker teacher admin].each do |role|
  Role.find_or_create_by!(name: role)
end

%w[web utilitar educational multimedia roboti].each do |category|
  Category.find_or_create_by!(name: category)
end

current_edition = Edition.find_or_initialize_by(
  name: "InfoEducație Demo 2026"
)
current_edition.assign_attributes(
  year: 2026,
  camp_start_date: Date.new(2026, 7, 20),
  camp_end_date: Date.new(2026, 7, 24),
  motto: "Construim idei, testăm viitorul",
  registration_start_date: DateTime.new(2026, 6, 1, 0, 0, 0),
  registration_end_date: DateTime.new(2026, 6, 30, 0, 0, 0),
  travel_data_deadline: nil,
  published: true,
  current: true,
  show_results: true,
  projects_forum_category: "demo-2026-projects",
  talks_forum_category: "demo-2026-talks"
)
current_edition.save!

admin_email = ENV.fetch("ADMIN_EMAIL", "admin@example.test")
admin_password = ENV["ADMIN_PASSWORD"]

if admin_password.present? && !User.exists?(email: admin_email)
  user = User.new(
    email: admin_email,
    password: admin_password,
    password_confirmation: admin_password,
    first_name: "Demo",
    last_name: "Administrator"
  )
  user.skip_confirmation!
  user.save!
  user.roles << Role.find_by!(name: "admin")
end

# This entirely fictional dataset gives local UI development realistic content
# without copying production or personal data. Names, schools, projects,
# results, biographies, URLs and all private registration fields are invented.
seed_demo_data = ActiveModel::Type::Boolean.new.cast(
  ENV.fetch("SEED_DEMO_DATA", Rails.env.development?)
)

if seed_demo_data
  demo_password = ENV.fetch("DEMO_USER_PASSWORD", "local-infoedu-demo-2026")

  seed_user = lambda do |email:, first_name:, last_name:, job: nil, job_en: nil|
    user = User.find_or_initialize_by(email: email)
    user.assign_attributes(
      first_name: first_name,
      last_name: last_name,
      job: job,
      job_en: job_en
    )

    if user.new_record?
      user.password = demo_password
      user.password_confirmation = demo_password
      user.skip_confirmation!
    end

    user.save!
    user
  end

  contestant_role = Role.find_by!(name: "contestant")
  alumni_role = Role.find_by!(name: "alumni")
  speaker_role = Role.find_by!(name: "speaker")

  participant_data = [
    {
      key: :budget_quest,
      first_name: "Mara",
      last_name: "Demo",
      school_name: "Liceul Demonstrativ Nord",
      county: "Județ Demo Nord",
      city: "Oraș Demo",
      mentor_first_name: "Elena",
      mentor_last_name: "Mentor"
    },
    {
      key: :parallel_dreams,
      first_name: "Tudor",
      last_name: "Exemplu",
      school_name: "Colegiul Exemplu",
      county: "Județ Exemplu",
      city: "Exempluville",
      mentor_first_name: "Dan",
      mentor_last_name: "Profesor"
    },
    {
      key: :flexibot_ada,
      first_name: "Ada",
      last_name: "Fictivă",
      school_name: "Liceul Tehnologic Fictiv",
      county: "Județ Demo Est",
      city: "Municipiul Fictiv",
      mentor_first_name: "Mira",
      mentor_last_name: "Exemplu"
    },
    {
      key: :flexibot_radu,
      first_name: "Radu",
      last_name: "Mostră",
      school_name: "Liceul Tehnologic Fictiv",
      county: "Județ Demo Est",
      city: "Municipiul Fictiv",
      mentor_first_name: "Mira",
      mentor_last_name: "Exemplu"
    },
    {
      key: :pixel_vault,
      first_name: "Ioana",
      last_name: "Simulare",
      school_name: "Colegiul Local de Informatică",
      county: "Județ Local",
      city: "Oraș Local",
      mentor_first_name: "Teo",
      mentor_last_name: "Ghid"
    },
    {
      key: :code_garden_victor,
      first_name: "Victor",
      last_name: "Local",
      school_name: "Academia Demo Digital",
      county: "Județ Test",
      city: "Testopolis",
      mentor_first_name: "Ana",
      mentor_last_name: "Demo"
    },
    {
      key: :code_garden_sonia,
      first_name: "Sonia",
      last_name: "Test",
      school_name: "Academia Demo Digital",
      county: "Județ Test",
      city: "Testopolis",
      mentor_first_name: "Radu",
      mentor_last_name: "Îndrumător"
    }
  ]

  participant_groups = [
    {
      members: [[:eco_atlas_daria, "Daria", "Demo"], [:eco_atlas_luca, "Luca", "Verde"]],
      school_name: "Colegiul Verde Demonstrativ",
      county: "Judet Demo Sud",
      city: "Verdegrad",
      mentor_first_name: "Irina",
      mentor_last_name: "Ghid"
    },
    {
      members: [[:logic_lab, "Andrei", "Logic"]],
      school_name: "Liceul Fictiv Central",
      county: "Judet Mostra",
      city: "Mostreni",
      mentor_first_name: "Sorin",
      mentor_last_name: "Model"
    },
    {
      members: [[:soundscapes_ilinca, "Ilinca", "Cadru"], [:soundscapes_matei, "Matei", "Pixel"]],
      school_name: "Liceul Creativ Demo",
      county: "Judet Scena",
      city: "Cadropolis",
      mentor_first_name: "Oana",
      mentor_last_name: "Studio"
    },
    {
      members: [[:paper_shadow, "Eva", "Scena"]],
      school_name: "Academia Vizuala Exemplu",
      county: "Judet Lumina",
      city: "Luminis",
      mentor_first_name: "Calin",
      mentor_last_name: "Regizor"
    },
    {
      members: [[:seed_rover_rares, "Rares", "Motor"], [:seed_rover_cora, "Cora", "Senzor"]],
      school_name: "Colegiul Tehnic Demo",
      county: "Judet Mecanic",
      city: "Rotoria",
      mentor_first_name: "Vlad",
      mentor_last_name: "Atelier"
    },
    {
      members: [[:aqua_sentinel, "Denis", "Circuit"]],
      school_name: "Liceul Experimental Local",
      county: "Judet Delta Demo",
      city: "Aquapolis",
      mentor_first_name: "Diana",
      mentor_last_name: "Prototip"
    },
    {
      members: [[:study_compass_bianca, "Bianca", "Plan"], [:study_compass_paul, "Paul", "Orar"]],
      school_name: "Colegiul Orizont Fictiv",
      county: "Judet Orizont",
      city: "Planesti",
      mentor_first_name: "Ioan",
      mentor_last_name: "Organizator"
    },
    {
      members: [[:safe_notes, "Miruna", "Cheie"]],
      school_name: "Liceul Digital Mostra",
      county: "Judet Cheie",
      city: "Criptograd",
      mentor_first_name: "Alina",
      mentor_last_name: "Model"
    },
    {
      members: [[:civic_pulse_daria, "Daria", "Retea"], [:civic_pulse_mihai, "Mihai", "Portal"]],
      school_name: "Academia Civica Demo",
      county: "Judet Agora",
      city: "Agora Noua",
      mentor_first_name: "Mihnea",
      mentor_last_name: "Web"
    },
    {
      members: [[:museum_mapper, "Lia", "Harta"]],
      school_name: "Colegiul Patrimoniu Exemplu",
      county: "Judet Muzeu",
      city: "Galeria",
      mentor_first_name: "Sabina",
      mentor_last_name: "Curator"
    }
  ]

  participant_groups.each do |group|
    group.fetch(:members).each do |key, first_name, last_name|
      participant_data << group.except(:members).merge(key:, first_name:, last_name:)
    end
  end

  contestants = participant_data.each_with_index.to_h do |data, index|
    user = seed_user.call(
      email: "participant-#{data[:key]}@example.test",
      first_name: data[:first_name],
      last_name: data[:last_name]
    )
    user.roles << contestant_role unless user.roles.include?(contestant_role)

    contestant = Contestant.find_or_initialize_by(
      user: user,
      edition: current_edition
    )
    contestant.assign_attributes(
      address: "Adresă locală de test #{index + 1}",
      city: data[:city],
      county: data[:county],
      country: "România",
      zip_code: "000000",
      sex: 3,
      cnp: "LOCAL-DEMO-#{index + 1}",
      id_card_type: "DEMO",
      id_card_number: "DEMO-2026-#{index + 1}",
      phone_number: "+40000000000",
      school_name: data[:school_name],
      grade: "XI",
      school_county: data[:county],
      school_city: data[:city],
      school_country: "România",
      date_of_birth: Date.new(2009, 1, index + 1),
      mentoring_teacher_first_name: data[:mentor_first_name],
      mentoring_teacher_last_name: data[:mentor_last_name],
      official: true,
      present_in_camp: true,
      paying_camp_accommodation: false
    )
    contestant.save!

    [data[:key], contestant]
  end

  project_data = [
    {
      title: "Budget Quest",
      category: "educational",
      contestant_keys: [:budget_quest],
      description: "Joc educațional fictiv despre administrarea unui buget lunar și luarea deciziilor financiare responsabile.",
      technical_description: "Aplicație demonstrativă Flutter cu stocare locală și lecții definite în fișiere JSON.",
      system_requirements: "Telefon Android demonstrativ sau emulator local.",
      source_url: "https://example.test/projects/budget-quest",
      homepage: nil,
      score: 72.5,
      extra_score: 18.0,
      prize: "I"
    },
    {
      title: "Parallel Dreams",
      category: "multimedia",
      contestant_keys: [:parallel_dreams],
      description: "Scurtmetraj fictiv despre două versiuni paralele ale aceluiași oraș imaginar.",
      technical_description: "Animație 2D și montaj demonstrativ realizate cu unelte grafice locale.",
      system_requirements: "Player video și sistem audio.",
      source_url: "https://example.test/projects/parallel-dreams",
      homepage: nil,
      score: 70.0,
      extra_score: 16.5,
      prize: "I"
    },
    {
      title: "FlexiBot",
      category: "roboti",
      contestant_keys: [:flexibot_ada, :flexibot_radu],
      description: "Braț robotic fictiv care sortează cuburi colorate într-un traseu demonstrativ.",
      technical_description: "Prototip demonstrativ cu microcontroler, senzori de culoare și servomotoare.",
      system_requirements: "Microcontroler generic, trei servomotoare și un banc local de test.",
      source_url: "https://example.test/projects/flexibot",
      homepage: nil,
      score: 75.0,
      extra_score: 14.25,
      prize: "I"
    },
    {
      title: "Pixel Vault",
      category: "utilitar",
      contestant_keys: [:pixel_vault],
      description: "Utilitar fictiv pentru organizarea, etichetarea și arhivarea colecțiilor de imagini.",
      technical_description: "Aplicație desktop demonstrativă cu index local și căutare după etichete.",
      system_requirements: "Calculator cu minimum 4 GB RAM și spațiu local pentru fișiere demo.",
      source_url: "https://example.test/projects/pixel-vault",
      homepage: nil,
      score: 73.25,
      extra_score: 19.75,
      prize: "I"
    },
    {
      title: "Code Garden",
      category: "web",
      contestant_keys: [:code_garden_victor, :code_garden_sonia],
      description: "Platformă web fictivă în care elevii învață programare cultivând o grădină virtuală.",
      technical_description: "Aplicație demonstrativă React cu API local și bază de date PostgreSQL.",
      system_requirements: "Browser modern și conexiune la serverul local de dezvoltare.",
      source_url: "https://example.test/projects/code-garden",
      homepage: "https://code-garden.example.test",
      score: 76.0,
      extra_score: 20.0,
      prize: "I"
    }
  ]

  additional_projects = [
    {
      title: "Eco Atlas",
      category: "educational",
      contestant_keys: [:eco_atlas_daria, :eco_atlas_luca],
      description: "Atlas educational fictiv cu misiuni despre ecosisteme si consum responsabil.",
      homepage: "https://eco-atlas.example.test",
      score: 69.5,
      extra_score: 17.0,
      prize: "II"
    },
    {
      title: "Logic Lab",
      category: "educational",
      contestant_keys: [:logic_lab],
      description: "Laborator fictiv de puzzle-uri care explica algoritmi prin experimente scurte.",
      score: 64.0,
      extra_score: 15.5,
      prize: "III"
    },
    {
      title: "Soundscapes",
      category: "multimedia",
      contestant_keys: [:soundscapes_ilinca, :soundscapes_matei],
      description: "Experienta multimedia fictiva despre sunetele unui oras imaginar pe durata unei zile.",
      homepage: "https://soundscapes.example.test",
      score: 67.75,
      extra_score: 18.0,
      prize: "II"
    },
    {
      title: "Paper Shadow",
      category: "multimedia",
      contestant_keys: [:paper_shadow],
      description: "Animatie fictiva din decoruri de hartie despre curaj si colaborare.",
      score: 62.5,
      extra_score: 14.0,
      prize: "III"
    },
    {
      title: "Seed Rover",
      category: "roboti",
      contestant_keys: [:seed_rover_rares, :seed_rover_cora],
      description: "Robot fictiv care monitorizeaza rasaduri si simuleaza udarea selectiva.",
      score: 71.25,
      extra_score: 15.0,
      prize: "II"
    },
    {
      title: "Aqua Sentinel",
      category: "roboti",
      contestant_keys: [:aqua_sentinel],
      description: "Prototip fictiv pentru observarea parametrilor apei intr-un bazin demonstrativ.",
      score: 65.5,
      extra_score: 13.5,
      prize: "III"
    },
    {
      title: "Study Compass",
      category: "utilitar",
      contestant_keys: [:study_compass_bianca, :study_compass_paul],
      description: "Organizator fictiv pentru teme, sesiuni de studiu si obiective saptamanale.",
      homepage: "https://study-compass.example.test",
      score: 68.0,
      extra_score: 16.25,
      prize: "II"
    },
    {
      title: "Safe Notes",
      category: "utilitar",
      contestant_keys: [:safe_notes],
      description: "Carnet fictiv pentru notite locale organizate si protejate cu o parola demonstrativa.",
      score: 63.75,
      extra_score: 14.5,
      prize: "III"
    },
    {
      title: "Civic Pulse",
      category: "web",
      contestant_keys: [:civic_pulse_daria, :civic_pulse_mihai],
      description: "Portal civic fictiv pentru propuneri locale, sondaje si urmarirea ideilor comunitatii.",
      homepage: "https://civic-pulse.example.test",
      score: 72.0,
      extra_score: 18.5,
      prize: "II"
    },
    {
      title: "Museum Mapper",
      category: "web",
      contestant_keys: [:museum_mapper],
      description: "Ghid web fictiv pentru explorarea exponatelor si construirea unor tururi tematice.",
      homepage: "https://museum-mapper.example.test",
      score: 66.25,
      extra_score: 15.75,
      prize: "III"
    }
  ]

  project_data.concat(additional_projects.map do |data|
    slug = data.fetch(:title).parameterize
    {
      technical_description: "Proiect demonstrativ pentru verificarea fluxurilor locale de participanti si rezultate.",
      system_requirements: "Browser modern sau mediu local de test.",
      source_url: "https://example.test/projects/#{slug}",
      homepage: nil
    }.merge(data)
  end)

  project_data.each do |data|
    project = Project.find_or_initialize_by(
      title: data[:title],
      edition: current_edition
    )
    project.assign_attributes(
      category: Category.find_by!(name: data[:category]),
      contestants: data[:contestant_keys].map { |key| contestants.fetch(key) },
      description: data[:description],
      technical_description: data[:technical_description],
      system_requirements: data[:system_requirements],
      source_url: data[:source_url],
      homepage: data[:homepage],
      open_source: true,
      finished: true,
      status: Project::STATUS_APPROVED,
      score: data[:score],
      extra_score: data[:extra_score],
      prize: data[:prize]
    )
    project.save!
  end

  news_articles = [
    {
      title: "Ediția demonstrativă 2026 este pregătită",
      title_en: "The 2026 demo edition is ready",
      pinned: true,
      body: <<~HTML,
        <p><strong>Acesta este un articol fictiv folosit pentru dezvoltarea interfeței locale.</strong></p>
        <p>Motto demonstrativ: <em>Construim idei, testăm viitorul!</em></p>
        <p>Conținutul, datele și locurile din această bază de date sunt inventate.</p>
      HTML
      body_en: <<~HTML
        <p><strong>This is a fictional article used to develop and test the local interface.</strong></p>
        <p>Demo motto: <em>We build ideas and test the future!</em></p>
        <p>All content, dates, and locations in this database are invented.</p>
      HTML
    },
    {
      title: "Rezultatele demonstrative sunt disponibile",
      title_en: "The demo results are available",
      pinned: false,
      body: <<~HTML,
        <p>Rezultatele fictive pentru ediția demonstrativă 2026 sunt acum vizibile în interfața locală.</p>
        <p>Toate numele, proiectele și punctajele afișate sunt date de test inventate.</p>
      HTML
      body_en: <<~HTML
        <p>The fictional results for the 2026 demo edition are now visible in the local interface.</p>
        <p>Every displayed name, project, and score is invented test data.</p>
      HTML
    }
  ]

  news_articles.each do |data|
    article = News.find_or_initialize_by(
      title: data[:title],
      edition: current_edition
    )
    article.assign_attributes(
      title_en: data[:title_en],
      body: data[:body],
      body_en: data[:body_en],
      pinned: data[:pinned]
    )
    article.save!
  end

  speaker_data = [
    {
      key: :ana_arhitect,
      first_name: "Ana",
      last_name: "Arhitect",
      job: "Ingineră software la Fabrica Demo",
      job_en: "Software engineer at Demo Factory"
    },
    {
      key: :vlad_senzor,
      first_name: "Vlad",
      last_name: "Senzor",
      job: "Inginer robotică la Laboratorul Fictiv",
      job_en: "Robotics engineer at Fictional Lab"
    },
    {
      key: :ioana_cadru,
      first_name: "Ioana",
      last_name: "Cadru",
      job: "Designer multimedia la Studio Exemplu",
      job_en: "Multimedia designer at Example Studio"
    },
    {
      key: :mihai_date,
      first_name: "Mihai",
      last_name: "Date",
      job: "Cercetător AI la Institutul Local",
      job_en: "AI researcher at Local Institute"
    },
    {
      key: :daria_produs,
      first_name: "Daria",
      last_name: "Produs",
      job: "Product manager la Atelierul Digital",
      job_en: "Product manager at Digital Workshop"
    },
    {
      key: :radu_siguranta,
      first_name: "Radu",
      last_name: "Siguranță",
      job: "Inginer de securitate la Scut Demo",
      job_en: "Security engineer at Demo Shield"
    },
    {
      key: :elena_comunitate,
      first_name: "Elena",
      last_name: "Comunitate",
      job: "Coordonatoare la Clubul Exemplu",
      job_en: "Coordinator at Example Club"
    },
    {
      key: :matei_prezentare,
      first_name: "Matei",
      last_name: "Prezentare",
      job: "Trainer tehnic independent",
      job_en: "Independent technical trainer"
    }
  ]

  speakers = speaker_data.to_h do |data|
    user = seed_user.call(
      email: "speaker-#{data[:key]}@example.test",
      first_name: data[:first_name],
      last_name: data[:last_name],
      job: data[:job],
      job_en: data[:job_en]
    )
    user.roles << speaker_role unless user.roles.include?(speaker_role)
    [data[:key], user]
  end

  talk_data = [
    {
      title: "De la idee la un prototip care poate fi testat",
      title_en: "From an idea to a testable prototype",
      speaker_keys: [:ana_arhitect],
      description: "Seminar fictiv despre alegerea unei probleme clare, construirea primei versiuni și folosirea feedbackului pentru iterații rapide.",
      description_en: "A fictional talk about choosing a clear problem, building the first version, and using feedback for rapid iterations."
    },
    {
      title: "Roboți mici, experimente mari",
      title_en: "Small robots, big experiments",
      speaker_keys: [:vlad_senzor],
      description: "Atelier fictiv despre senzori, motoare și teste simple care ajută o echipă să descopere erorile înainte de demonstrația finală.",
      description_en: "A fictional workshop about sensors, motors, and simple tests that help a team find errors before the final demonstration."
    },
    {
      title: "Poveste, sunet și interacțiune",
      title_en: "Story, sound, and interaction",
      speaker_keys: [:ioana_cadru, :matei_prezentare],
      description: "Discuție fictivă despre cum se combină imaginile, sunetul și ritmul unei prezentări pentru un proiect multimedia memorabil.",
      description_en: "A fictional discussion about combining visuals, sound, and presentation rhythm to create a memorable multimedia project."
    },
    {
      title: "Inteligență artificială explicată prin date",
      title_en: "Artificial intelligence explained through data",
      speaker_keys: [:mihai_date],
      description: "Introducere fictivă în seturi de date, evaluarea rezultatelor și limitele unui model, cu exemple potrivite pentru proiecte școlare.",
      description_en: "A fictional introduction to datasets, result evaluation, and model limitations, with examples suitable for school projects."
    },
    {
      title: "Construiește pentru oameni, nu doar pentru demo",
      title_en: "Build for people, not only for the demo",
      speaker_keys: [:daria_produs, :elena_comunitate],
      description: "Seminar fictiv despre interviuri scurte, accesibilitate și prioritizarea funcționalităților care rezolvă o nevoie reală.",
      description_en: "A fictional talk about short interviews, accessibility, and prioritizing features that solve a real need."
    },
    {
      title: "Securitate practică pentru proiecte web",
      title_en: "Practical security for web projects",
      speaker_keys: [:radu_siguranta],
      description: "Sesiune fictivă despre parole, date personale, permisiuni și verificările de bază care fac o aplicație demonstrativă mai sigură.",
      description_en: "A fictional session about passwords, personal data, permissions, and basic checks that make a demo application safer."
    }
  ]

  talk_data.each do |data|
    talk = Talk.find_or_initialize_by(
      title: data[:title],
      edition: current_edition
    )
    talk.assign_attributes(
      title_en: data[:title_en],
      description: data[:description],
      description_en: data[:description_en],
      users: data[:speaker_keys].map { |key| speakers.fetch(key) }
    )
    talk.save!
  end

  historical_edition_names = {
    2018 => "2018",
    2020 => "2020",
    2022 => "2022",
    2024 => "2024"
  }

  historical_editions = historical_edition_names.to_h do |year, name|
    edition = Edition.find_or_initialize_by(year: year)
    edition.assign_attributes(
      name: name,
      year: year,
      motto: "InfoEducație #{year}",
      registration_start_date: DateTime.new(year, 1, 1),
      registration_end_date: DateTime.new(year, 1, 2),
      projects_forum_category: "Lucrări #{year}",
      talks_forum_category: "Prezentări #{year}",
      published: false,
      current: false,
      show_results: false
    )
    edition.save!
    [year, edition]
  end

  alumni_data = [
    {
      email: "alumnus-alex-demo@example.test",
      first_name: "Alex",
      last_name: "Demo",
      job: "Inginer software la Atelierul Digital",
      job_en: "Software engineer at Digital Workshop",
      edition_years: [2022, 2024],
      description: "Biografie fictivă: edițiile demonstrative m-au încurajat să experimentez, să colaborez și să îmi prezint ideile mai clar.",
      description_en: "Fictional biography: the demo editions encouraged me to experiment, collaborate, and present my ideas more clearly."
    },
    {
      email: "alumnus-mara-exemplu@example.test",
      first_name: "Mara",
      last_name: "Exemplu",
      job: "Designer de produs la Studio Mostră",
      job_en: "Product designer at Sample Studio",
      edition_years: [2024],
      description: "Biografie fictivă: experiența demo mi-a arătat cât de mult contează feedbackul, lucrul în echipă și o prezentare bine repetată.",
      description_en: "Fictional biography: the demo experience showed me how much feedback, teamwork, and a well-rehearsed presentation matter."
    },
    {
      email: "alumnus-vlad-prototip@example.test",
      first_name: "Vlad",
      last_name: "Prototip",
      job: "Inginer robotică la Laboratorul Local",
      job_en: "Robotics engineer at Local Lab",
      edition_years: [2018, 2020],
      description: "Biografie fictivă: primele prototipuri construite pentru concurs mi-au transformat curiozitatea pentru senzori într-o pasiune pentru robotică.",
      description_en: "Fictional biography: the first prototypes I built for the competition turned my curiosity about sensors into a passion for robotics."
    },
    {
      email: "alumnus-ioana-pixel@example.test",
      first_name: "Ioana",
      last_name: "Pixel",
      job: "Artistă tehnică la Cadru Fictiv",
      job_en: "Technical artist at Fictional Frame",
      edition_years: [2020, 2022],
      description: "Biografie fictivă: proiectele multimedia m-au învățat să combin povestea, ilustrația și codul într-o experiență coerentă.",
      description_en: "Fictional biography: multimedia projects taught me to combine storytelling, illustration, and code into a coherent experience."
    },
    {
      email: "alumnus-radu-circuit@example.test",
      first_name: "Radu",
      last_name: "Circuit",
      job: "Dezvoltator embedded la Placa Demo",
      job_en: "Embedded developer at Demo Board",
      edition_years: [2018],
      description: "Biografie fictivă: feedbackul primit în tabără m-a ajutat să simplific ideile tehnice și să construiesc prototipuri mai ușor de testat.",
      description_en: "Fictional biography: feedback from the camp helped me simplify technical ideas and build prototypes that were easier to test."
    },
    {
      email: "alumnus-elena-retea@example.test",
      first_name: "Elena",
      last_name: "Rețea",
      job: "Ingineră platformă la Norul Exemplu",
      job_en: "Platform engineer at Example Cloud",
      edition_years: [2020, 2024],
      description: "Biografie fictivă: colaborarea cu participanți din alte județe mi-a deschis drumul către sisteme distribuite și comunități tehnice.",
      description_en: "Fictional biography: collaborating with participants from other counties led me toward distributed systems and technical communities."
    },
    {
      email: "alumnus-tudor-harta@example.test",
      first_name: "Tudor",
      last_name: "Hartă",
      job: "Cercetător UX la Busola Digitală",
      job_en: "UX researcher at Digital Compass",
      edition_years: [2022],
      description: "Biografie fictivă: discuțiile cu juriul m-au făcut să observ mai atent cum folosesc oamenii produsele și unde întâmpină dificultăți.",
      description_en: "Fictional biography: discussions with the jury taught me to observe more carefully how people use products and where they struggle."
    },
    {
      email: "alumnus-daria-logica@example.test",
      first_name: "Daria",
      last_name: "Logică",
      job: "Ingineră de date la Setul Fictiv",
      job_en: "Data engineer at Fictional Dataset",
      edition_years: [2018, 2022, 2024],
      description: "Biografie fictivă: pregătirea rezultatelor pentru prezentare mi-a arătat cât de valoroase sunt datele clare și explicațiile bine structurate.",
      description_en: "Fictional biography: preparing results for presentation showed me the value of clear data and well-structured explanations."
    },
    {
      email: "alumnus-matei-verde@example.test",
      first_name: "Matei",
      last_name: "Verde",
      job: "Fondator al Eco Atelier Demo",
      job_en: "Founder of Demo Eco Workshop",
      edition_years: [2020],
      description: "Biografie fictivă: concursul mi-a dat încrederea să transform un experiment despre mediu într-un proiect construit împreună cu o echipă.",
      description_en: "Fictional biography: the competition gave me the confidence to turn an environmental experiment into a project built with a team."
    },
    {
      email: "alumnus-sabina-sistem@example.test",
      first_name: "Sabina",
      last_name: "Sistem",
      job: "Mentor tehnic la Clubul Exemplu",
      job_en: "Technical mentor at Example Club",
      edition_years: [2018, 2020, 2022, 2024],
      description: "Biografie fictivă: după mai multe ediții demonstrative, am continuat să ajut echipe tinere să își testeze ideile și să învețe din iterații.",
      description_en: "Fictional biography: after several demo editions, I continued helping young teams test their ideas and learn through iteration."
    }
  ]

  alumni_data.each do |data|
    user = seed_user.call(
      email: data[:email],
      first_name: data[:first_name],
      last_name: data[:last_name],
      job: data[:job],
      job_en: data[:job_en]
    )
    user.roles << alumni_role unless user.roles.include?(alumni_role)

    alumnus = Alumnus.find_or_initialize_by(user: user)
    alumnus.description = data[:description]
    alumnus.description_en = data[:description_en]
    alumnus.editions = data[:edition_years].map do |year|
      historical_editions.fetch(year)
    end
    alumnus.save!
  end

  sponsor_tier_data = [
    {
      key: :partners,
      name: "Parteneri educaționali",
      name_en: "Educational partners",
      position: 10,
      previous_names: []
    },
    {
      key: :gold,
      name: "Sponsori Gold",
      name_en: "Gold sponsors",
      position: 20,
      previous_names: ["Sponsori principali"]
    },
    {
      key: :silver,
      name: "Sponsori Silver",
      name_en: "Silver sponsors",
      position: 30,
      previous_names: ["Susținători"]
    }
  ]

  Sponsor.where(
    title: [
      "Atelierul Pixel",
      "Laboratorul Verde",
      "Norul Demo",
      "Fabrica de Roboți",
      "Studio Exemplu",
      "Rețeaua Curioasă"
    ]
  ).destroy_all

  sponsor_tiers = sponsor_tier_data.to_h do |data|
    tier = SponsorTier
      .where(name: [data[:name], *data[:previous_names]])
      .first_or_initialize
    tier.assign_attributes(
      name: data[:name],
      name_en: data[:name_en],
      position: data[:position]
    )
    tier.save!
    [data[:key], tier]
  end

  sponsor_data = [
    {
      title: "Ministerul Educației",
      website_url: "https://www.edu.ro/",
      tier: :partners,
      position: 10,
      image_filename: "edu.jpg"
    },
    {
      title: "Uniunea Profesorilor de Informatică din România",
      website_url: "https://upir.ro/",
      tier: :partners,
      position: 20,
      image_filename: "upir.png"
    },
    {
      title: "Consiliul Județean Vrancea",
      website_url: "https://cjvrancea.ro/",
      tier: :partners,
      position: 30,
      image_filename: "logoCJVrancea.jpg"
    },
    {
      title: "Universitatea Națională de Știință și Tehnologie POLITEHNICA București",
      website_url: "https://upb.ro/",
      tier: :partners,
      position: 40,
      image_filename: "upb-ro.png"
    },
    {
      title: "Universitatea de Vest din Timișoara",
      website_url: "https://uvt.ro/",
      tier: :partners,
      position: 50,
      image_filename: "uvt.png"
    },
    {
      title: "Viva Credit",
      website_url: "https://vivacredit.ro/",
      tier: :gold,
      position: 10,
      image_filename: "vivacredit.png"
    },
    {
      title: "Bitdefender",
      website_url: "https://bitdefender.com/",
      tier: :gold,
      position: 20,
      image_filename: "bitdefender.jpg"
    },
    {
      title: "Orange",
      website_url: "https://orange.ro/",
      tier: :gold,
      position: 30,
      image_filename: "orange.png"
    },
    {
      title: "Cisco",
      website_url: "https://cisco.com/",
      tier: :gold,
      position: 40,
      image_filename: "cisco.png"
    },
    {
      title: "Intuitext",
      website_url: "https://www.intuitext.ro/",
      tier: :gold,
      position: 50,
      image_filename: "intuitext.png"
    },
    {
      title: "Leonte",
      website_url: "https://leonte.ro/",
      tier: :silver,
      position: 10,
      image_filename: "leonte.png"
    },
    {
      title: "Easyhost",
      website_url: "https://ro.easyhost.com/",
      tier: :silver,
      position: 20,
      image_filename: "easyhost.png"
    },
    {
      title: "InfoBits Academy",
      website_url: "https://ebooks.infobits.ro/",
      tier: :silver,
      position: 30,
      image_filename: "link_infobits_academy.jpg"
    },
    {
      title: "Sindicatul Liber din Învățământ Vrancea",
      website_url: "https://slivrancea.blogspot.com/",
      tier: :silver,
      position: 40,
      image_filename: "SindicatVrancea.jpg"
    },
    {
      title: "CyberEDU",
      website_url: "https://www.cyber-edu.co/",
      tier: :silver,
      position: 50,
      image_filename: "cyberedu.png"
    },
    {
      title: "Micromet",
      website_url: "https://www.micromet.ro/",
      tier: :silver,
      position: 60,
      image_filename: "micromet.jpg"
    },
    {
      title: "Electric SRL",
      website_url: "https://www.electricsrl.ro/",
      tier: :silver,
      position: 70,
      image_filename: "electric.png"
    }
  ]

  # These are the same official logo assets used by infoeducatie-ui.
  sponsor_asset_directory = Rails.root.join("db", "seed_assets", "sponsors")

  sponsor_data.each do |data|
    sponsor = Sponsor.find_or_initialize_by(title: data[:title])
    sponsor.assign_attributes(
      sponsor_tier: sponsor_tiers.fetch(data[:tier]),
      website_url: data[:website_url],
      position: data[:position],
      active: true
    )

    sponsor.remove_image! if sponsor.persisted? && sponsor.image?
    File.open(sponsor_asset_directory.join(data[:image_filename])) do |file|
      sponsor.image = file
      sponsor.save!
    end
  end

  # Current jury content and images from the official infoeducatie-ui jury page.
  jury_data = JSON.parse(
    Rails.root.join("db", "seed_assets", "jury", "data.json").read,
    symbolize_names: true
  )
  jury_icon_directory = Rails.root.join("db", "seed_assets", "jury", "icons")
  jury_photo_directory = Rails.root.join("db", "seed_assets", "jury", "photos")

  jury_data.each do |category_data|
    category = JuryCategory.find_or_initialize_by(title: category_data[:title])
    category.assign_attributes(
      title_en: category_data[:title_en],
      position: category_data[:position],
      active: true
    )

    category.remove_icon! if category.persisted? && category.icon?
    if category_data[:icon_filename].present?
      File.open(jury_icon_directory.join(category_data[:icon_filename])) do |file|
        category.icon = file
        category.save!
      end
    else
      category.save!
    end

    category_data[:members].each do |member_data|
      member = category.jury_members.find_or_initialize_by(name: member_data[:name])
      member.assign_attributes(
        title: member_data[:title],
        title_en: member_data[:title_en],
        occupation: member_data[:occupation],
        occupation_en: member_data[:occupation_en],
        position: member_data[:position],
        active: true
      )

      member.remove_photo! if member.persisted? && member.photo?
      File.open(jury_photo_directory.join(member_data[:photo_filename])) do |file|
        member.photo = file
        member.save!
      end
    end
  end

  # Exact judging-criteria PDFs currently published by data.infoeducatie.ro.
  judging_criteria_data = JSON.parse(
    Rails.root.join("db", "seed_assets", "judging_criteria", "data.json").read,
    symbolize_names: true
  )
  judging_criteria_directory = Rails.root.join(
    "db",
    "seed_assets",
    "judging_criteria",
    "documents"
  )

  judging_criteria_data.each do |criterion_data|
    criterion = JudgingCriterion.find_or_initialize_by(title: criterion_data[:title])
    criterion.assign_attributes(
      title_en: criterion_data[:title_en],
      position: criterion_data[:position],
      active: true
    )

    if criterion.document?
      criterion.save!
    else
      File.open(
        judging_criteria_directory.join(criterion_data[:document_filename])
      ) do |file|
        criterion.document = file
        criterion.save!
      end
    end
  end

  # Photo albums, links, and cover images currently published by infoeducatie.ro.
  photo_album_data = JSON.parse(
    Rails.root.join("db", "seed_assets", "photo_albums", "data.json").read,
    symbolize_names: true
  )
  photo_album_cover_directory = Rails.root.join(
    "db",
    "seed_assets",
    "photo_albums",
    "covers"
  )

  photo_album_data.each do |album_data|
    album = PhotoAlbum.find_or_initialize_by(title: album_data[:title])
    album.assign_attributes(
      title_en: album_data[:title_en],
      external_url: album_data[:external_url],
      position: album_data[:position],
      active: true
    )

    if album.cover_image?
      album.save!
    else
      File.open(
        photo_album_cover_directory.join(album_data[:cover_filename])
      ) do |file|
        album.cover_image = file
        album.save!
      end
    end
  end

  # Permanent pages currently published by infoeducatie.ro. A future blog can
  # reuse the same editor and media library without coupling dated posts to
  # navigation-critical content.
  content_page_directory = Rails.root.join("db", "seed_assets", "content_pages")
  seed_content_page = lambda do |slug:, title:, title_en:, document_filename: nil|
    page = ContentPage.find_or_initialize_by(slug: slug)
    page.assign_attributes(
      title: title,
      title_en: title_en,
      body: content_page_directory.join(slug, "body.ro.html").read,
      body_en: content_page_directory.join(slug, "body.en.html").read,
      active: true
    )
    page.save!

    if document_filename && !page.document?
      File.open(content_page_directory.join(slug, document_filename)) do |file|
        page.document = file
        page.save!
      end
    end
  end

  seed_content_page.call(
    slug: "about",
    title: "Despre InfoEducație",
    title_en: "About InfoEducație"
  )
  seed_content_page.call(
    slug: "contact",
    title: "Contact",
    title_en: "Contact"
  )
  seed_content_page.call(
    slug: "program",
    title: "Program InfoEducație",
    title_en: "InfoEducation Schedule",
    document_filename: "program-2026.pdf"
  )

  blog_post_directory = Rails.root.join("db", "seed_assets", "blog_posts")
  blog_post_data = JSON.parse(
    blog_post_directory.join("data.json").read,
    symbolize_names: true
  )

  blog_post_data.each do |post_data|
    post = BlogPost.find_or_initialize_by(slug: post_data[:slug])
    post.assign_attributes(
      title: post_data[:title],
      excerpt: post_data[:excerpt],
      body: blog_post_directory.join(
        post_data[:slug],
        "body.ro.html"
      ).read,
      author_name: post_data[:author_name],
      category: post_data[:category],
      published_at: Time.zone.parse(post_data[:published_at]),
      active: true
    )
    post.save!
  end
end
