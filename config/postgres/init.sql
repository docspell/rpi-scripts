CREATE USER docspell WITH PASSWORD 'docspell' LOGIN CREATEDB;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO docspell;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO docspell;