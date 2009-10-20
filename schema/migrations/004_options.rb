migration 4, :options do
  up do
    execute %q{
      alter table users
        add column hide_tooltips tinyint(1) default '0',
        add column hide_visited tinyint(1) default '0',
        add column show_new_window tinyint(1) default '0'
    }
  end

  down do
    execute %q{
      alter table users
        drop column hide_tooltips,
        drop column hide_visited,
        drop column show_new_window
    }
  end
end

