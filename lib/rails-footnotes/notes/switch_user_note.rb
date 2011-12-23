module Footnotes
  module Notes
    class SwitchUserNote < AbstractNote
      def initialize(controller)
        if defined?(SwitchUser)
          @users = SwitchUser.available_users
          @controller = controller
        end
      end

      def title
        "Switch User"
      end
      
      def valid?
        defined?(SwitchUser)
      end

      def content
        if defined?(SwitchUser)
          if @users.empty?
            ""
          else
            links = []
          
            @users.each do |scope, user_proc|
              current = @controller.instance_variable_get(:"@current_#{scope}")
              identifier = SwitchUser.available_users_identifiers[scope]
              name = SwitchUser.available_users_names[scope]
              user_proc.call.each do |user|
                
                linktext = "[#{user.send(identifier)}] #{user.send(name)}"
                
                if current and current.send(identifier) == user.send(identifier)
                  links << "<strong>#{linktext}</strong>"
                else
                  url = '/switch_user?scope_identifier=' + escape("#{scope}_#{user.send(identifier)}")
                  links << "<a href='#{url}'>#{linktext}</a>"
                end
              end
            end
                  
            "<ul><li>#{links.join("</li><li>")}</li></ul>"
          end
        else
          "switch_user gem is not installed."
        end
      end
    end
  end
end
