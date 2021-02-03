## Description

This app uses Ruby 2.7.2 and Rails ~> 6.1.1

## Instructions

To run this app locally you have to run in the project root.

`bundle exec  bin/setup`

It will create one admin user

`email: admin@strv.com`  
`password: admin1`

One organization

`name: STRV`

And one regular user

`user@strv.com`  
`password: user11`

Both admin and user are under STRV organization.

After that you have to paste the json key inside of key.json.  
And paste the proper envs inside of .env.local and .env.test

`PROJECT_ID=<>project_id`
`GOOGLE_APPLICATION_CREDENTIALS="./key.json"`

## Endpoints

### POST /api/v1/registrations
##### request
```
{
    "registration": {
        "user": {
            "email": <email>,
            "password": <password>
        }
        "organizations_ids": <array of ids>
}
```
#### response
```
{
    "user": {
        "id": <id>,
        "email": <email>
    },
    "token": <token>
}
```

### POST /api/v1/authentications
##### request
```
{
    "authentication": {
            "email": <email>,
            "password": <password>
    }
}
```
#### response
```
{
    "token": <token>
}
```

Every request from needs the header

`Authorization: Bearer <token> `

### GET /api/v1/organizations
#### response
```
{
    "organizations": [
        {
            "id": <id>,
            "name": <name>,
            "created_at": <created_at>,
            "updated_at": <updated_at>
        },
    ]
}
```

### POST /api/v1/organizations
Only admin user
#### request
```
{
    "organization": {
        "name": <name>
    }
}
```
#### response
```
{
    "organization": {
        "id": <id>,
        "name": <name>,
        "created_at": <created_at>,
        "updated_at": <updated_at>
    }
}
```

### GET /api/v1/contacts
#### request
```
{
    "organization_id": 1
}
```
#### response
```
{
    "contacts": [
        {
            "id": <id_from_firebase>,
            "name": <name>,
            "email": <email>,
            "phone": <phone>,
            "organization_id": <organization_id> 
        }
    ]
}
```

### POST /api/v1/contacts
#### request
```
{
    "contact": {
        "name": <name>,
        "email": <email>,
        "phone": <phone>,
        "organization_id": <organization_id>
    }
}
```
#### response
```
{
    "contact": {
        "id": <id_from_firebase>,
        "name": <name>,
        "email": <email>,
        "phone": <phone>,
        "organization_id": <organization_id>
    }
}
```

### PUT /api/v1/contacts/:id
#### request
```
{
    "contact": {
        "name": <name>,
        "email": <email>,
        "phone": <phone>,
        "organization_id": <organization_id>
    }
}
```
#### response
```
{
    "contact": {
        "id": <id_from_firebase>,
        "name": <name>,
        "email": <email>,
        "phone": <phone>,
        "organization_id": <organization_id>
    }
}
```

### DELETE /api/v1/contacts/:id
#### response
204 No Content

## Tests

The project uses Rspec for testing. To run it run in the root project

`bundle exec rspec`

It will run all the test suite.

The project tests the integration to Firebase without mocks or stubs.