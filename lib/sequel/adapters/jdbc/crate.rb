require 'jdbc/crate'
Jdbc::Crate.load_driver

Sequel.require 'adapters/shared/crate'

module Sequel
  module JDBC
    Sequel.synchronize do
      DATABASE_SETUP[:crate] = proc do |db|
        db.extend(Sequel::JDBC::Crate::DatabaseMethods)
        db.extend_datasets Sequel::Crate::DatasetMethods

        #table names in crate are always downcased unless you double-quote them. so Table gets table, but "Table" remains Table
        #sequel will quote table names so dont do anything to it
        db.identifier_input_method = nil

        Jdbc::Crate::Driver::CrateDriver
      end
    end

    # Database and Dataset instance methods for Crate specific
    # support via JDBC.
    module Crate
      # Database instance methods for Crate databases accessed via JDBC.
      module DatabaseMethods

        # # there is no AUTOINCREMENT
        def serial_primary_key_options
          {:primary_key => true, :type=>:String}
        end


        #only one string type called 'string'
        def type_literal_generic_string(column)
          :string
        end

        #crate supports integer, long, short, double, float and byte
        def type_literal_generic_numeric(column)
          :double
        end

        def type_literal_generic_float(column)
          :double
        end

        def type_literal_generic_bignum(column)
          :integer
        end

        def type_literal_generic_integer(column)
          :integer
        end

        #Sequel error wrapper will swallow exceptions without this
        def database_error_classes
          [Java::IoCrateActionSql::SQLActionException]
        end

        #this isn't called but needed so that sequel will do schema parsing
        #sequel asks: respond_to?(:schema_parse_table, true)
        def schema_parse_table(table_name, opts)
        end

        #crate doesnt support transactions
        def begin_transaction(*args); end
        def commit_transaction(*args); end
        def rollback_transaction(*args); end


      end

      module DatasetMethods

      end

    end
  end
end
