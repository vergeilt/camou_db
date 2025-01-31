# camou_db

`camou_db` is a lightweight SQLite database library for FiveM, providing a simple interface for highly performant database operations.

## Features

- Create tables
- Insert, update, and delete records
- Execute raw SQL queries
- Select records with optional filtering

## Installation

1. Clone the repository to your FiveM resources directory:
    ```sh
    git clone https://github.com/vergeilt/camou_db [camou]/camou_db
    ```

2. Add camou_db to your `server.cfg`:
    ```cfg
    ensure camou_db
    ```

## Usage

```lua
local db = exports["camou_db"]

-- Create a table
db:createTable('users', {
    id = 'INTEGER PRIMARY KEY',
    name = 'TEXT',
    age = 'INTEGER'
})

-- Insert a record
db:insert('users', { name = 'John Doe', age = 30 })

-- Select records
local users = db:select('users', { 'id', 'name', 'age' })
for _, user in ipairs(users) do
    print(user.id, user.name, user.age)
end
```

## License

This project is licensed under the MIT License.
Feel free to customize it further based on your specific needs.