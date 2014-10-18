delete from volunteers;
\copy volunteers from 'volunteers.csv' DELIMITER ',' CSV HEADER;
