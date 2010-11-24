#!/bin/bash

commands() {
cat <<SQL
  begin;
    create table links(
      id                bigserial,
      url               text,
      title             varchar(255),
      referrers         text,
      score_delicious   float default '0',
      score_digg        float default '0',
      score_frequency   float default '0',
      score_freshness   float default '0',
      score_reddit      float default '0',
      score_swarm       float default '0',
      score_twitter     float default '0',
      score_ycombinator float default '0',
      score_average     float default '0',
      score             float default '0',
      velocity_average  float default '0',
      velocity          float default '0',
      score_at          timestamp default null,
      referred_at       timestamp default now(),
      created_at        timestamp default now(),
      updated_at        timestamp default now(),
      unique(url),
      primary key(id)
    );

    create table feeds(
      id            bigserial,
      title         varchar(255),
      site          text,
      url           text not null,
      etag          text default null,
      last_modified timestamp default null,
      total_links   integer default '0',
      daily_links   float default '0',
      created_at    timestamp default now(),
      updated_at    timestamp default now(),
      unique(url),
      primary key(id)
    );

    create table feed_links(
      feed_id bigint not null,
      link_id bigint not null,
      url text,
      primary key(feed_id, link_id),
      foreign key(feed_id) references feeds(id) on delete cascade,
      foreign key(link_id) references links(id) on delete cascade
    );

    create table themes(
      id   serial,
      name varchar(20),
      primary key(id)
    );

    create table users(
      id              serial,
      theme_id        integer not null,
      email           text not null,
      username        varchar(20) not null,
      password        varchar(40) not null,
      password_reset  varchar(40),
      gravatar        text,
      show_new_window boolean default false,
      updated_at      timestamp default now(),
      created_at      timestamp default now(),
      unique(username),
      primary key(id),
      foreign key(theme_id) references themes(id)
    );

    create table user_feeds(
      user_id integer not null,
      feed_id bigint not null,
      score   float default '0.5',
      primary key(user_id, feed_id),
      foreign key(user_id) references users(id) on delete cascade,
      foreign key(feed_id) references feeds(id) on delete cascade
    );

  commit;
SQL
}

commands | psql --set ON_ERROR_STOP= oursignal
exit $?
