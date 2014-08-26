require 'jdbc/crate'
Jdbc::Crate.load_driver

Sequel.require 'adapters/shared/crate'

module Sequel
  module JDBC
    Sequel.synchronize do
      DATABASE_SETUP[:crate] = proc do |db|
        db.extend(Sequel::JDBC::Crate::DatabaseMethods)
        db.extend_datasets Sequel::Crate::DatasetMethods
        db.identifier_input_method = nil
        Jdbc::Crate::Driver::CrateDriver
      end
    end

    # Database and Dataset instance methods for Crate specific
    # support via JDBC.
    module Crate
      # Database instance methods for Crate databases accessed via JDBC.
      module DatabaseMethods

        def database_type
          :crate
        end
      end

      module DatasetMethods

      end

    end
  end
end
