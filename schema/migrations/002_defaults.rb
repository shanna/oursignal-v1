migration 2, :defaults do
  up do
    execute %q{insert into themes (name) values ('treemap'), ('list')}

    # Not ideal.
    User.first_or_create({:username => 'oursignal'},
      :username => 'oursignal',
      :email    => 'enquiries@oursignal.com',
      :password => 'a8uf9e8jsk3jlwr' # guess that :P
    )
  end

  down do
    execute %q{delete from themes where name in ('treemap', 'list')}
    execute %q{delete from users where username = 'oursignal'}
  end
end
