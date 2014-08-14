module Qualtrics
  class Transaction
    class TransactionRecord
      INVERSE_MAP = {
          'create' => 'delete'
      }

      attr_reader :operation, :result
      def initialize(operation, result)
        @operation = operation
        @result = result
      end

      def has_inverse?
        !inverse_command.nil?
      end

      def inverse_command
        INVERSE_MAP[@operation.command]
      end

      def inverse_action
        "#{inverse_command}#{operation.entity_name}"
      end

      def issue_inverse_request
        primary_key_name = "#{operation.entity_name}ID"
        Qualtrics::Operation.new(:post, inverse_action, {
          'LibraryID' => operation.options['LibraryID'],
          primary_key_name => @result[primary_key_name]
        }).disable_listeners do |op|
          op.issue_request
        end
      end
    end

    def initialize
      @op_stack = {}
    end

    def received_response(operation, response)
      push(operation, response) if queue?(operation, response)
    end

    def push(operation, response)
      @op_stack[operation.entity_name] ||= []
      @op_stack[operation.entity_name] << TransactionRecord.new(operation, response.result)
    end

    def entity_id(response)
      response.result["#{operation.entity_name}ID"]
    end

    def rollback!
      @op_stack.each do |entity_type, transaction_records|
        while rec = transaction_records.shift do
          if rec.has_inverse?
            rec.issue_inverse_request
          end
        end
      end
    end

    COMMANDS_TO_TRACK = ['create']
    protected
    def queue?(operation, response)
      response.success? && !response.result.nil? && COMMANDS_TO_TRACK.include?(operation.command)
    end
  end
end