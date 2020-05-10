# Gym Partner
![gym partner logo](https://gympartner.s3-us-west-1.amazonaws.com/brand/facebook_cover_photo_2.png)

## About
Gym Partner is an app that helps you plan exercise routines, set fitness goals, and track your improvement over time.

This is the JSON REST API for the Gym Partner project. This application is built with Rails 6.0.2 and Ruby 2.6.5, is currently configured to use the PostgreSQL database, and is currently hosted on Heroku at https://gympartner.herokuapp.com/.

The main responsibility of this API is to serve as a back-end for both the React and Android user interfaces. It's designed to receive HTTP requests sent to it by web and mobile clients, properly handle it, and return necessary data back to the clients in JSON format. By nature of being RESTful, this API is stateless, and it provides a uniform interface for access to its resources. A full list of endpoints can be found [here](https://github.com/coped/gym-partner-api/wiki/Endpoints).

The other two applications involved in the Gym Partner project can be found here:
* [Gym Partner web-client repository](https://github.com/coped/gym-partner-web-client)
* [Gym Partner Android repository](https://github.com/coped/gym-partner-android)

## Getting started
You can get started by signing up at https://gympartner.app

## Data for exercises
Data for exercise descriptions and images were sourced from the [Everkinetic data repository](https://github.com/everkinetic/data). Many thanks to them.

## Learn more
For more in-depth information about this application, please refer to the [gym-partner-api wiki](https://github.com/coped/gym-partner-api/wiki).

## Contributions
If you'd like to make a contribution, open an issue or a pull request with a good explanation of your changes, and we can have a discussion from there.

## Contact and support
If you have any questions or concerns, feel free to send me an email at **dennisaaroncope@gmail.com**

## Created By
Dennis Cope, https://coped.dev
