module MaterializedView
  extend ActiveSupport::Concern

  included do
    def readonly?
      true
    end
  end

  class_methods do
    def refresh
      connection.execute("REFRESH MATERIALIZED VIEW CONCURRENTLY #{quoted_table_name}")
    end
  end
end
