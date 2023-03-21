create database salon;

create table customers (
	customer_id SERIAL PRIMARY KEY,
	name VARCHAR(255) not null,
	phone VARCHAR(50) unique
);

create table appointments (
	appointment_id SERIAL PRIMARY KEY,
	customer_id INT not null,
	service_id INt not null,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	FOREIGN KEY (service_id) REFERENCES services(service_id),
	time VARCHAR(10)
);

create table services (
	service_id SERIAL PRIMARY KEY,
	name VARCHAR(255) not null
);

insert into services (name) values ('Cut');
insert into services (name) values ('Polish');
insert into services (name) values ('Shave');
