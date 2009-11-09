migration 1, :os do
  up do
    execute %q{drop table if exists themes}
    execute %q{
      create table themes (
        id int(11) unsigned not null auto_increment,
        name varchar(50) not null,
        primary key (id)
      ) engine=innodb default charset=utf8
    }

    execute %q{drop table if exists users}
    execute %q{
      create table users (
        id int(11) unsigned not null auto_increment,
        theme_id int(11) unsigned not null,
        username varchar(20) not null,
        password varchar(40) default null,
        password_reset varchar(40) default null,
        email varchar(255) not null,
        openid varchar(255) default null,
        description varchar(255) default null,
        tags varchar(255) default null,
        created_at datetime default null,
        updated_at datetime default null,
        primary key (id),
        unique key (username),
        index (theme_id),
        foreign key (theme_id) references themes(id) on delete no action on update no action
      ) engine=innodb default charset=utf8
    }

    execute %q{drop table if exists feeds}
    execute %q{
      create table feeds (
        id varchar(40) not null,
        title varchar(255) default null,
        site varchar(255) default null,
        url varchar(255) not null,
        etag varchar(255) default null,
        last_modified datetime default null,
        total_links int(11) default '0',
        daily_links float default '0',
        created_at datetime default null,
        updated_at datetime default null,
        primary key (id),
        unique key (url),
        index (created_at),
        index (updated_at)
      ) engine=innodb default charset=utf8
    }

    execute %q{drop table if exists links}
    execute %q{
      create table links (
        id varchar(40) not null,
        url varchar(255) not null,
        title varchar(255) default null,
        domains text default null,
        referrers text default null,
        score_average float default '0',
        score_bonus float default '0',
        score float default '0',
        velocity_average float default '0',
        velocity float default '0',
        score_at datetime default null,
        meta_at datetime default null,
        referred_at datetime default null,
        created_at datetime default null,
        updated_at datetime default null,
        primary key (id),
        unique key (url),
        index (score),
        index (velocity),
        index (score_at),
        index (meta_at),
        index (created_at),
        index (updated_at)
      ) engine=innodb default charset=utf8
    }

    execute %q{drop table if exists feed_links}
    execute %q{
      create table feed_links (
        feed_id varchar(40) not null,
        link_id varchar(40) not null,
        url varchar(255) not null,
        primary key (feed_id, link_id),
        index (link_id),
        index (feed_id),
        index (url),
        foreign key (link_id) references links(id) on delete cascade on update cascade,
        foreign key (feed_id) references feeds(id) on delete cascade on update cascade
      ) engine=innodb default charset=utf8
    }

    execute %q{drop table if exists user_feeds}
    execute %q{
      create table user_feeds (
        user_id int(11) unsigned not null,
        feed_id varchar(40) not null,
        score float default '0.5',
        primary key (user_id, feed_id),
        index (user_id),
        index (feed_id),
        foreign key (user_id) references users(id) on delete cascade on update cascade,
        foreign key (feed_id) references feeds(id) on delete cascade on update cascade
      ) engine=innodb default charset=utf8
    }

    execute %q{drop table if exists scores}
    execute %q{
      create table scores (
        id varchar(40) not null,
        source varchar(50) not null,
        url varchar(255) not null,
        score float default '0',
        created_at datetime default null,
        updated_at datetime default null,
        primary key (id),
        index (url),
        index (score)
      ) engine=innodb default charset=utf8
    }
  end

  down do
    execute %q{drop table if exists scores}
    execute %q{drop table if exists user_feeds}
    execute %q{drop table if exists feed_links}
    execute %q{drop table if exists links}
    execute %q{drop table if exists feeds}
    execute %q{drop table if exists users}
    execute %q{drop table if exists themes}
  end
end
