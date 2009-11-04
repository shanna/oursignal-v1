migration 7, :add_velocities_index do
  up do
    execute %q{alter table velocities add index (velocity)}
    execute %q{alter table scores add index (score)}
  end

  down do
  end
end

