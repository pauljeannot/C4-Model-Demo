workspace "Toulouse.rb Meetup Management System" "A system to manage meetups for the Toulouse.rb community." {

    model {
        member = person "Meetup member" "A community member who attends meetups."
        organizer = person "Organizer" "Organizes and manages meetups."
        speaker = person "Speaker" "Delivers presentations at meetups."

        group "Toulouse.rb hosted services" {
            toulouseRbSystem = softwaresystem "Toulouse.rb" "Manages the details and registration of meetups." {
                railsApp = container "Rails Monolith" "" "Ruby on Rails" {
                    memberRegistration = component "Member Registration Controller" "Handles member registration and profile updates." "Ruby on Rails Controller"
                    eventManagement = component "Event Management Controller" "Allows organizers to create and manage events." "Ruby on Rails Controller"
                    presentationManagement = component "Presentation Management Controller" "Allows speakers to submit and update their presentations." "Ruby on Rails Controller"
                    messagesController = component "Messages Controller" "Creates jobs for sending emails and SMS to members about upcoming meetups and changes." "Ruby on Rails Controller"
                    railsAdmin = component "Rails Admin" "Provides an administrative interface for managing data." "Rails Admin Gem"
                }
                frontend = container "Frontend" "" "Hotwire" "Web Browser"
                backOffice = container "Back Office" "" "Rails Admin" "Web Browser"
                database = container "Database" "" "PostgreSQL 16" "Database"
                sidekiq = container "Sidekiq" "" "Ruby Sidekiq"
            }
        }

        group "Third Party Services" {
            emailProvider = softwaresystem "E-mail Provider" "Sendgrid" {
                tags "Third Party Services"
            }
            smsProvider = softwaresystem "SMS Provider" "Twilio" {
                tags "Third Party Services"
            }
        }

        // Relationships
        member -> frontend "Interacts with" "HTTPS"
        speaker -> frontend "Interacts with" "HTTPS"
        organizer -> frontend "Interacts with" "HTTPS"
        organizer -> backOffice "Interacts with" "HTTPS"

        frontend -> railsApp "Interacts with" "HTTPS"
        backOffice -> railsApp "Interacts with" "HTTPS"

        emailProvider -> member "Sends e-mail to"
        smsProvider -> member "Sends SMS to"
        
        messagesController -> sidekiq "Enqueues jobs in"
        sidekiq -> emailProvider "Sends e-mail using"
        sidekiq -> smsProvider "Sends SMS using"    
    
        memberRegistration -> database "Reads from and writes to"
        eventManagement -> database "Reads from and writes to"
        presentationManagement -> database "Reads from and writes to"
        railsAdmin -> database "Manages data from"

        deploymentEnvironment "Single VM Production" {
            deploymentNode "toulouse-rb-production" "" "Debian 12.5 LTS" {
                tags "Debian Host"
                containerInstance railsApp
                containerInstance database
                containerInstance sidekiq
            }

            deploymentNode "Web Browser" {
                containerInstance frontend
                containerInstance backOffice
            }

            deploymentNode "Sendgrid" {
                softwareSystemInstance emailProvider
            }

            deploymentNode "Twilio  " {
                softwareSystemInstance smsProvider
            }
        }

        deploymentEnvironment "Hybrid Public Cloud Production" {
            deploymentNode "Heroku" {
                deploymentNode "Performance Dyno" {
                    tags "Heroku Performance Dyno"
                    containerInstance railsApp 
                }

                deploymentNode "Basic Dyno" {
                    tags "Heroku Basic Dyno"
                    containerInstance sidekiq
                }
            }

            deploymentNode "ScaleWay" "" "Optimized DB-POP2-2C-8G" {
                tags "ScaleWay Production-Optimized"
                containerInstance database
            }

            deploymentNode "Web Browser" {
                containerInstance frontend
                containerInstance backOffice
            }

            deploymentNode "Sendgrid" {
                softwareSystemInstance emailProvider
            }

            deploymentNode "Twilio" {
                softwareSystemInstance smsProvider
            }
        }
    }

    views {       
        systemContext toulouseRbSystem "SystemContext" {
            include *
            autoLayout
        }

        container toulouseRbSystem "Containers" {
            include *
        }

        component railsApp "Components" {
            include *
            autoLayout
        }
    
        deployment * "Single VM Production" {
            include *
        }

        deployment * "Hybrid Public Cloud Production" {
            include *
        }

        styles {
            element "Person" {
                color #ffffff
                background #E7186B
                fontSize 22
                shape Person
            }
            element "Third Party Services" {
                background #153F6A
                color #ffffff
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Container" {
                background #9F1770
                shape RoundedBox
                color #ffffff
            }
            element "Component" {
                background #54457F
                shape RoundedBox
                color #FFFFFF
            }
            element "Database" {
                shape Cylinder
            }
            element "Web Browser" {
                shape WebBrowser
                background #E6176B
                color #ffffff
            }
            element "Debian Host" {
                icon debian.png
                color #AA002C
                stroke #AA002C
            }
            element "Heroku Performance Dyno" {
                icon heroku-performance.png
                color #AA002C
                stroke #AA002C
            }
            element "Heroku Basic Dyno" {
                icon heroku-basic.png
                color #AA002C
                stroke #AA002C
            }
            element "ScaleWay Production-Optimized" {
                icon scaleway.png
                color #AA002C
                stroke #AA002C
            }
        }
    }
}
