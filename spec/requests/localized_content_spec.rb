require "rails_helper"

RSpec.describe "Localized public content", type: :request do
  let!(:edition) { create(:edition, current: false) }

  describe "GET /v1/news.json" do
    let!(:article) do
      create(
        :news,
        edition: edition,
        title: "Titlu românesc",
        title_en: "English title",
        body: "<p>Conținut românesc suficient de lung pentru afișarea articolului complet în listă.</p>",
        body_en: "<p>English content long enough to display the complete article body in the list.</p>"
      )
    end

    it "returns English content when requested" do
      get "/v1/news.json", params: {edition: edition.id, locale: "en"}

      article_json = JSON.parse(response.body).first
      expect(article_json["title"]).to eq("English title")
      expect(article_json["body"]).to include("English content")
      expect(article_json["short"]).to include("English content")
    end

    it "returns Romanian content by default" do
      get "/v1/news.json", params: {edition: edition.id}

      article_json = JSON.parse(response.body).first
      expect(article_json["title"]).to eq("Titlu românesc")
      expect(article_json["body"]).to include("Conținut românesc")
    end
  end

  describe "GET /v1/talks.json" do
    let!(:speaker) do
      create(
        :user,
        job: "Inginer software",
        job_en: "Software engineer"
      )
    end
    let!(:talk) do
      create(
        :talk,
        edition: edition,
        users: [speaker],
        title: "Titlu seminar",
        title_en: "Talk title",
        description: "Descriere seminar",
        description_en: "Talk description"
      )
    end

    it "returns English talk and speaker content when requested" do
      get "/v1/talks.json", params: {edition: edition.id, locale: "en"}

      talk_json = JSON.parse(response.body).first
      expect(talk_json["title"]).to eq("Talk title")
      expect(talk_json["description"]).to eq("Talk description")
      expect(talk_json.dig("users", 0, "job")).to eq("Software engineer")
    end

    it "falls back to Romanian fields when English content is blank" do
      talk.update!(title_en: nil, description_en: nil)
      speaker.update!(job_en: nil)

      get "/v1/talks.json", params: {edition: edition.id, locale: "en"}

      talk_json = JSON.parse(response.body).first
      expect(talk_json["title"]).to eq("Titlu seminar")
      expect(talk_json["description"]).to eq("Descriere seminar")
      expect(talk_json.dig("users", 0, "job")).to eq("Inginer software")
    end
  end

  describe "GET /v1/alumni.json" do
    let!(:alumnus_user) do
      create(
        :user,
        job: "Designer de produs",
        job_en: "Product designer"
      )
    end
    let!(:alumnus) do
      create(
        :alumnus,
        user: alumnus_user,
        editions: [edition],
        description: "Biografie românească",
        description_en: "English biography"
      )
    end

    it "returns English biography and job content when requested" do
      get "/v1/alumni.json", params: {locale: "en"}

      alumnus_json = JSON.parse(response.body).find do |entry|
        entry.dig("user", "email_md5") == alumnus_user.email_md5
      end
      expect(alumnus_json["description"]).to eq("English biography")
      expect(alumnus_json.dig("user", "job")).to eq("Product designer")
    end

    it "returns Romanian content by default" do
      get "/v1/alumni.json"

      alumnus_json = JSON.parse(response.body).find do |entry|
        entry.dig("user", "email_md5") == alumnus_user.email_md5
      end
      expect(alumnus_json["description"]).to eq("Biografie românească")
      expect(alumnus_json.dig("user", "job")).to eq("Designer de produs")
    end
  end
end
