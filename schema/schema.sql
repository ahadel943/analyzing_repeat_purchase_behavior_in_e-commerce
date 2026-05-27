-- create database
create database ecomm;

-- add pgcrypto extenstion for the uuid support
create extension if not exists "pgcrypto";

-- create customers table
create table customers (
    customer_id uuid primary key default gen_random_uuid(),
    signup_date date not null,
    customer_type text check ( customer_type in ('one_time', 'occasional', 'loyal') ),
    city text,
    created_at timestamp default now()
);

-- create products table
create table products (
    product_id uuid primary key default gen_random_uuid(),
    product_name text,
    category text check ( category in ('electronics', 'clothing', 'home', 'beauty') ),
    price numeric(10, 2),
    product_type text check ( product_type in ('hot', 'normal', 'dead') ),
    created_at timestamp default now()
);

-- create orders table
create table orders (
    order_id uuid primary key default gen_random_uuid(),
    customer_id uuid references customers(customer_id),
    order_date timestamp not null,
    total_amount numeric(10, 2),
    status text not null default 'completed' check ( status in ('completed', 'cancelled') ),
    created_at timestamp default now()
);

-- create order_items table
create table order_items (
    order_item_id uuid primary key default gen_random_uuid(),
    order_id uuid references orders(order_id),
    product_id uuid references products(product_id),
    quantity int check ( quantity > 0 ),
    price numeric(10, 2)
);

-- indexes
CREATE INDEX idx_orders_customer_date ON orders(customer_id, order_date);
CREATE INDEX idx_orders_status_date ON orders(status, order_date);
CREATE INDEX idx_order_items_order_product ON order_items(order_id, product_id);
CREATE INDEX idx_customers_type ON customers(customer_type);
CREATE INDEX idx_products_category ON products(category);



