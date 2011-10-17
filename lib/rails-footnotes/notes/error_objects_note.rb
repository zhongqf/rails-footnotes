module Footnotes
  module Notes
    class ErrorObjectsNote < AssignsNote

      def title
        "Error Objects (#{errors.size})"
      end

      def valid?
        errors
      end

      def content
        rows = []
        errors.each do |key|
          rows << [ key, escape(error_content(key)) ]
        end
        mount_table(rows.unshift(['Object', 'Errors']), :class => 'error_objects', :summary => "Debug information for #{title}")
      end

      protected
      
        def object_of(key)
          @controller.instance_variable_get(key)
        end
        
        def has_errors?(obj)
          obj && obj.respond_to?(:errors) && obj.errors.present?
        end
      
        def errors
          error = []
          assigns.each do |key|
            error << key if has_errors?(object_of(key))
          end
          error
        end
        
        def error_content(key)
          object_of(key).errors.full_messages.join(", ")
        end

    end
  end
end
