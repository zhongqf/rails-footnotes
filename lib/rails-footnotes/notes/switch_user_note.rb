module Footnotes
  module Notes
    class SwitchUserNote < AbstractNote
      def initialize(controller)
        if defined?(SwitchUser)
          @users = SwitchUser.available_users
          @controller = controller
          @template = controller.instance_variable_get(:@template)
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
          if @users.empty or @template.nil?
            ""
          else
            links = []
          
            @users.each do |scope, user_proc|
              current = @controller.instance_variable_get(:"current_#{scope}")
              identifier = SwitchUser.available_users_identifiers[scope]
              name = SwitchUser.available_users_names[scope]
              user_proc.call.each do |user|
                
                linktext = "[#{user.send(identifier)}] #{user.send(name)}"
                
                if current and current.send(identifier) == user.send(identifier)
                  links << @template.content_tag(:strong, linktext)
                else
                  url = '/switch_user?scope_identifier=' + encodeURIComponent("#{scope}_#{user.send(identifier)}")
                  links << @template.link_to(linktext, url)
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
