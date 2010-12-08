migration 8, :william_theme do
  up do
    execute %q{insert into themes (name) values ('william')}
  end

  down do
    execute %q{delete from themes where name = 'original'}
  end
end

