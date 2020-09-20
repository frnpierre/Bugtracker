### Welcome to BugTracker, an app from my web developer portfolio.

It's a simple bug tracking system that I created to showcase my ruby on rails skills, with a focus on the back-end side, but I made sure to apply essential front-end design principles (proximity, alignment, contrast..)<br/>
You can play with a live version here: https://mybgtrack.herokuapp.com/ (It's hosted on a heroku free dyno so it might take a few seconds to start)

#### How I built it:

I chose to use Rails 5.2.3 , Bootstrap 4, PostgreSQL and Devise

I used a TDD process during the whole development, using RSpec, Capybara and FactoryBot  

*   I used outside-in testing for features requiring user interaction, starting with an integration spec (they are located in specs/system)
*   I used requests specs to test all actions and authorizations (they are located in specs/requests)


For authorizations, I chose to use before filters instead of using CanCanCan or Pundit  

*   Users can only access their own projects, or a project they are part of the team.
*   Everything you are allowed to do on these projects is explained on the project show page.


For validations I decided to enforce them:  

*   On the front-end with bootstrap form validations.
*   On the back-end with models validations.
*   I decided not to enforce them at the database level.
*   I decided to only validate presence of input


I put "Login as" buttons throughout the app for you to quickly switch between users and explore the differences.

If you have any questions, feel free to ask !