require 'date'

# Schema.
require 'oursignal/scheme/timestep'

module Oursignal
  class Timestep < Scheme::Timestep
    def self.find id
      case id
        when nil                  then nil
        when Integer              then get(id: id)
        when Time, DateTime, Date
          # TODO: Hrm this is going to be a table scan I think.
          execute(%q{
            select *, abs(date_part('epoch', created_at - ?)) as diff
            from timesteps
            order by diff asc
            limit 1
          }, id.to_time).first
        else find(DateTime.parse(id.to_s)) rescue find(id.to_s.to_i)
      end
    end

    def self.now
      execute(%q{
        select *
        from timesteps
        order by id desc
        limit 1
      }).first
    end
  end # Timestep
end # oursignal
