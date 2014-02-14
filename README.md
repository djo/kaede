## Chicago Boss Demo

Example of a simple Long Polling implementation based on [Chicago Boss](http://www.chicagoboss.org/) and [Backbone.js.](http://backbonejs.org/)

### Development

Install Erlang/OTP-R15 and [rebar](https://github.com/basho/rebar) build-tool. After that:

    ./rebar get-deps
    ./rebar compile
    ./init-dev.sh

And you'll get it on localhost:8001.

### Use Cases

Sign up:

* User fills in a registration form and submits.
* User is logged into the application.

Create a topic:

* Member (Registered User) views a topic list on the dashboard.
* Member fills in a topic subject and submits.
* Member sees a newly created topic at the top of the list.

Write a new message:

* Member chooses a topic by clicking the subject.
* Member adds a new message to the topic.
* All members who openned the topic before see a newly added message.

### Contributors

* [Andrew Djoga](https://github.com/Djo)
* [Alexander Kovalev](https://github.com/asskovalev)
* [Roman](https://github.com/fellz)
