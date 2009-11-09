migration 5, :velocities do
  up do
    execute %q{drop table if exists velocities}
    execute %q{
      create table velocities (
        link_id varchar(40) not null,
        velocity float not null,
        created_at datetime default null,
        primary key (link_id, created_at),
        index(created_at),
        index(velocity)
      ) engine=innodb default charset=utf8
    }
  end

  down do
    execute %q{drop table if exists velocities}
  end
end
