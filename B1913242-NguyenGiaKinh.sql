-- Tao database
create database CoffeeShopManagement;

-- Active database
use CoffeeShopManagement;

-- Tao tables
create table category (
	id int primary key  NOT NULL AUTO_INCREMENT,
	title nvarchar(50) not null
);

create table product(
	id int primary key  NOT NULL AUTO_INCREMENT,
	title nvarchar(150),
	price float,
	created_at date,    
	updated_at date,
	content text,
	id_cat int,
	constraint fk_id_cat foreign key (id_cat) references category(id)
);
create table staff(
	id int primary key  NOT NULL AUTO_INCREMENT,   
	fullname nvarchar(100), 
	birthday date,
    address nvarchar(100),
    pw varchar(16)
);

create table tab(
	id int primary key NOT NULL AUTO_INCREMENT,
    tabname nvarchar(100),
    slot int,
    stat int
);

create table orders(
	id int primary key  NOT NULL AUTO_INCREMENT,
    table_id int,
    orders_date date,
	constraint fk_table_id foreign key (table_id) references tab(id),
    total_price float,
    paid int,
	staff_id int,
    constraint fk_staff_id foreign key (staff_id) references staff(id)
);


create table order_detail(
	id int,
    product_id int,
    constraint fk_oder_detail_id foreign key (id) references orders(id),
	constraint fk_product_id foreign key (product_id) references product(id),
	amount int,
	price float,
	total_price int    
);

-- Nhap du lieu cho tat ca cac tables
insert into category(title)
values
('Trà'),
('Cà Phê'),
('Nước Ép'),
('Nước Ngọt'),
('Khác');

insert into product(title,price,created_at,updated_at,content,id_cat)
values
('Trà đào',16000,'2022-01-10','2022-01-20','abcxyz',1),
('Hồng trà',16000,'2022-01-10','2022-01-20','abcxyz',1),
('Trà Lipton',16000,'2022-01-10','2022-01-20','abcxyz',1),
('Cà phê đá',18000,'2022-01-10','2022-01-20','abcxyz',2),
('Cà phê sữa đá',22000,'2022-01-10','2022-01-20','abcxyz',2),
('Bạc xỉu',22000,'2022-01-10','2022-01-20','abcxyz',2),
('Nước ép cam',20000,'2022-01-10','2022-01-20','abcxyz',3),
('Nước ép ổi',20000,'2022-01-10','2022-01-20','abcxyz',3),
('Nước ép dưa hấu',20000,'2022-01-10','2022-01-20','abcxyz',3),
('Coca Cola',18000,'2022-01-10','2022-01-20','abcxyz',4),
('Pepsi',18000,'2022-01-10','2022-01-20','abcxyz',4),
('7 Up',18000,'2022-01-10','2022-01-20','abcxyz',4),
('Warior',18000,'2022-01-10','2022-01-20','abcxyz',4),
('Sữa chua đá',22000,'2022-01-10','2022-01-20','abcxyz',5),
('Cacao đá xay',22000,'2022-01-10','2022-01-20','abcxyz',5);

insert into staff(fullname,birthday,address,pw)
values
('Ngô Thị Cúc Hương','2001-05-02','Vĩnh Long','123'),
('Nguyễn Thị Thảo','1998-10-22','Cần Thơ','234'),
('Phạm Thị Huỳnh Như','2000-04-04','Cần Thơ','345'),
('Phạm Hoàng Siêu','2002-10-22','Cần Thơ','456');

insert into tab(tabname, slot, stat)
values
('BET1', 6, 1),
('BET2', 6, 1),
('BET3', 6, 1),
('BET4', 6, 1),
('LAU1', 4, 0),
('LAU2', 4, 0),
('LAU3', 2, 1),
('LAU4', 2, 1);

insert into orders(table_id, orders_date, total_price, paid, staff_id)
values
	(1, '2022-05-10', 32000, 0, 1),
	(2, '2022-05-10', 16000, 0, 2),
	(3, '2022-05-10', 48000, 0, 1),
	(4, '2022-05-10', 54000, 0, 3),
	(7, '2022-05-10', 16000, 1, 3),
	(8, '2022-05-10', 56000, 0, 4);

insert into order_detail(id, product_id, amount, price, total_price)
values
	(1,2,2,16000,32000),
	(2,1,1,16000,16000),
	(3,2,3,16000,48000),
	(4,3,3,18000,54000),
	(5,1,1,16000,16000),
	(6,3,1,16000,16000),
	(6,4,1,18000,18000),
	(6,6,1,22000,22000);

delimiter $
create procedure proc_view_order(idTab int)
begin
	select product.id, product.title, order_detail.amount, order_detail.price, order_detail.total_price from product, order_detail
	where product.id = order_detail.product_id and order_detail.id = (select id from orders
																		where orders.table_id = idTab and orders.paid != 1);
end$

-- Hien thi tong tien
delimiter $
create function orders_view_money(order_id int)
returns float
begin
	declare tp float;
	select sum(total_price) into tp
    from order_detail
		where order_detail.id = order_id;
	return tp;
end$