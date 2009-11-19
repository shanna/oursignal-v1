migration 7, :original_theme do
  up do
    execute %q{insert into themes (name) values ('original')}
  end

  down do
    execute %q{delete from themes where name = 'original'}
  end
end
