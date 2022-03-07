-- Method 1 
SELECT unnest(array['Katherine Underwood','Jason McDonald','Bella Kelly','Kimberly Ferguson','Paul Springer']) users;

-- Method 2
SELECT users
FROM (VALUES ('Katherine Underwood'),('Jason McDonald'),('Bella Kelly'),('Kimberly Ferguson'),('Paul Springer')
) t(users);