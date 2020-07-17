require "application_system_test_case"

class SubredditsTest < ApplicationSystemTestCase
  setup do
    @subreddit = subreddits(:one)
  end

  test "visiting the index" do
    visit subreddits_url
    assert_selector "h1", text: "Subreddits"
  end

  test "creating a Subreddit" do
    visit subreddits_url
    click_on "New Subreddit"

    fill_in "Description", with: @subreddit.description
    fill_in "Name", with: @subreddit.name
    click_on "Create Subreddit"

    assert_text "Subreddit was successfully created"
    click_on "Back"
  end

  test "updating a Subreddit" do
    visit subreddits_url
    click_on "Edit", match: :first

    fill_in "Description", with: @subreddit.description
    fill_in "Name", with: @subreddit.name
    click_on "Update Subreddit"

    assert_text "Subreddit was successfully updated"
    click_on "Back"
  end

  test "destroying a Subreddit" do
    visit subreddits_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Subreddit was successfully destroyed"
  end
end
