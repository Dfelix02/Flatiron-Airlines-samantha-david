# Flatiron Airlines
**Flatiron Airlines** is a CLI app that allows you to book a flight with Flatiron Airlines. 

## How to Install
1. Clone the repo onto your local machine.
1. Navigate to the repo directory from your terminal.
1. Run `bundle install` to install the required gems.
1. Run `rake db:migrate` to create the database.
1. Run `rake db:seed` to populate the database.
1. Run `ruby bin/run.rb` to open the app.

## Login / Register Menu
- Login if you already have an account
- Register if you don't have an account

## Main Menu
1. Book a Flight - Allows you to book a flight.
    -You can return to the main menu, confirm a flight, and create a new search from here.
2. View Reservations - Allows you to view your reservations.
    -You can cancel a reservation or return to the main menu from here.
3. Cancel Reservations - Allows you cancel a reservation.
    -You can return to the main menu from here.
4. Update Reservations - Allows you to update your reservation by canceling the selected reservation and making a new one.
5. Exit - Allows you to log out and return to the login/register menu.


## Tech Stack
- [TTY::Prompt](https://github.com/piotrmurach/tty-prompt)
- SQL

## Notion Page
- https://www.notion.so/Mod-1-Project-835eff55b57e4ae383c1444990d77745
