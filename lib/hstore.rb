# include this module
# to enable hstore atomic update for activerecord
module Hstore
  def hstore_update! field, hash
    table = self.class.table_name
    value = ActiveRecord::ConnectionAdapters::PostgreSQLColumn.hstore_to_string hash
    ActiveRecord::Base.connection.update_sql \
      %<update #{table} set "#{field}" = "#{field}" || (#{value}) where id=#{id}>
  end

  def hstore_delete! field, key
    table = self.class.table_name
    ActiveRecord::Base.connection.update_sql \
      %<update #{table} set "#{field}" = delete("#{field}", '#{key}')">
  end
end
