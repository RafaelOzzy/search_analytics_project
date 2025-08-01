Search Analytics App

This is a simple Ruby on Rails application that tracks search terms and displays analytics on most common searches.

Features

Allows users to search for articles via a front-end form.

Stores search terms in the database, filtered by IP address.

Prevents saving duplicate consecutive searches from the same IP.

Provides an analytics endpoint to return most searched terms.

Endpoints

POST /searches

Params: term (string)

Behavior:

Rejects terms shorter than 3 characters (400 Bad Request).

Ignores consecutive duplicates from the same IP.

GET /searches/analytics

Optional Param: ip (string)

Returns: JSON with most common search terms and counts.

GET /articles/search

Displays the search form and filtered articles based on input.

Setup

Clone the repository:

git clone https://github.com/your-username/search_analytics_app.git
cd search_analytics_app

Install dependencies:

bundle install

Setup the database:

rails db:create db:migrate

Run the server:

rails server

Running Tests

This app uses RSpec for testing. Run:

bundle exec rspec

Notes

To avoid consecutive duplicate searches from the same IP, the app checks the last saved search before saving a new one.

Articles are rendered dynamically based on search input.

This app is for demonstration purposes and does not include authentication or authorization.
