require "rails_helper"

RSpec.describe News, type: :model do
  describe "edition-scoped pinning" do
    let!(:first_edition) { create(:edition, current: false) }
    let!(:second_edition) { create(:edition, current: false) }
    let!(:first_pinned_article) do
      create(:news, edition: first_edition, pinned: true, title: "First edition pin")
    end
    let!(:second_pinned_article) do
      create(:news, edition: second_edition, pinned: true, title: "Second edition pin")
    end

    it "replaces the pinned article only within the same edition" do
      replacement = create(
        :news,
        edition: first_edition,
        pinned: true,
        title: "Replacement pin"
      )

      expect(replacement).to be_pinned
      expect(first_pinned_article.reload).not_to be_pinned
      expect(second_pinned_article.reload).to be_pinned
    end

    it "applies the same rule when pinning through an ordinary update" do
      replacement = create(:news, edition: first_edition, pinned: false)

      replacement.update!(pinned: true)

      expect(replacement).to be_pinned
      expect(first_pinned_article.reload).not_to be_pinned
      expect(second_pinned_article.reload).to be_pinned
    end
  end
end
