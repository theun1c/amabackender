CREATE SCHEMA amabackender; 

CREATE TABLE amabackender.users (
    id SERIAL PRIMARY KEY,
    version BIGINT NOT NULL DEFAULT 1,
    name VARCHAR(50) NOT NULL CHECK (char_length(name) BETWEEN 1 and 50),
    surname VARCHAR(50) CHECK (char_length(surname) BETWEEN 1 and 50),
    patronymic VARCHAR(50) CHECK (char_length(patronymic) BETWEEN 1 and 50),
    phone_number VARCHAR(15) CHECK ( phone_number ~ '^\+[0-9]+$' AND  char_length(phone_number) BETWEEN 10 and 15)
);

CREATE TABLE amabackender.tasks (
    id SERIAL PRIMARY KEY, 
    version BIGINT NOT NULL DEFAULT 1, 
    title VARCHAR(100) NOT NULL CHECK (char_length(title) BETWEEN 1 and 100), 
    description VARCHAR(1000) CHECK (char_length(description) BETWEEN 0 and 1000),
    completed BOOLEAN NOT NULL, 
    created_at TIMESTAMPTZ NOT NULL, 
    completed_at TIMESTAMPTZ,

    CHECK(
        (completed=FALSE AND completed_at IS NULL)
        OR 
        (completed=TRUE AND completed_at IS NOT NULL AND completed_at >= created_at)
    ),

    author_user_id INTEGER NOT NULL REFERENCES amabackender.users(id)
);