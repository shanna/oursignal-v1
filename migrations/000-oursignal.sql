create table links(
  id                       bigserial,
  url                      text,
  title                    varchar(255),
  native_score_delicious   float default '0',
  native_score_digg        float default '0',
  native_score_reddit      float default '0',
  native_score_twitter     float default '0',
  native_score_ycombinator float default '0',
  score_delicious          float default '0',
  score_digg               float default '0',
  score_frequency          float default '0',
  score_freshness          float default '0',
  score_reddit             float default '0',
  score_twitter            float default '0',
  score_ycombinator        float default '0',
  score_average            float default '0',
  score                    float default '0',
  velocity_average         float default '0',
  velocity                 float default '0',
  score_at                 timestamp default null,
  updated_at               timestamp default now(),
  created_at               timestamp default now(),
  unique(url),
  primary key(id)
);
create index links_updated_at_idx on links(updated_at);
create index links_score_at_idx on links(score_at);

create table feeds(
  id            bigserial,
  title         varchar(255),
  site          text,
  url           text not null,
  etag          text default null,
  last_modified timestamp default null,
  total_links   integer default '0',
  daily_links   float default '0',
  updated_at    timestamp default now(),
  created_at    timestamp default now(),
  unique(url),
  primary key(id)
);
create index feeds_updated_at_idx on feeds(updated_at);

create table feed_links(
  feed_id bigint not null,
  link_id bigint not null,
  url     text,
  unique(feed_id, url),
  primary key(feed_id, link_id),
  foreign key(feed_id) references feeds(id) on delete cascade,
  foreign key(link_id) references links(id) on delete cascade
);
create index feed_links_url_idx on feed_links(url);

create table themes(
  id   serial,
  name varchar(20),
  primary key(id)
);

create table users(
  id              serial,
  theme_id        integer not null,
  email           text not null,
  gravatar        text,
  username        varchar(20) not null,
  show_new_window boolean default false,
  updated_at      timestamp default now(),
  created_at      timestamp default now(),
  unique(username),
  unique(email),
  primary key(id),
  foreign key(theme_id) references themes(id)
);

create table authentications (
  provider     text not null,
  uid          text not null,
  user_id      int  not null,
  token        text default null,
  token_secret text default null,
  foreign key(user_id) references users(id) on delete cascade,
  primary key(provider, uid)
);

create table user_feeds(
  user_id integer not null,
  feed_id bigint not null,
  primary key(user_id, feed_id),
  foreign key(user_id) references users(id) on delete cascade,
  foreign key(feed_id) references feeds(id) on delete cascade
);

insert into themes (name) values
  ('list'),
  ('original'),
  ('treemap'),
  ('william')
;

