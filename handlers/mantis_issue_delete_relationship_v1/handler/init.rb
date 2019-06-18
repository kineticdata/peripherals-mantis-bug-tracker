# Require the dependencies file to load the vendor libraries
require File.expand_path(File.join(File.dirname(__FILE__), 'dependencies'))

class MantisIssueDeleteRelationshipV1
  # Initializes the handler and set the following instance variables:
  # * @input_document - A REXML::Document object that represents the input Xml.
  # * @info_values - A Hash of info value names to values.
  # * @parameters - A Hash of parameter names to parameter values.
  # * @client - A Savon::Client object that represents a connection to the
  #   configured web service.
  #
  # This is a required method that is automatically called by the Kinetic Task
  # Engine.
  #
  # ==== Parameters
  # * +input+ - The String of Xml that was built by evaluating the node.xml
  #   handler template.
  def initialize(input)
    # Set the input document attribute
    @input_document = REXML::Document.new(input)

    # Retrieve all of the handler info values and store them in a hash attribute
    # named @info_values.
    @info_values = {}
    REXML::XPath.match(@input_document, '/handler/infos/info').each do |node|
      # Associate the attribute name to the String value (stripping leading and
      # trailing whitespace)
      @info_values[node.attribute('name').value] = node.text
    end

    # Retrieve all of the handler parameters and store them in a hash attribute
    # named @parameters.
    @parameters = {}
    REXML::XPath.match(@input_document, '/handler/parameters/parameter').each do |node|
      # Associate the attribute name to the String value (stripping leading and
      # trailing whitespace)
      @parameters[node.attribute('name').value] = node.text
    end

    # Build the Savon::Client connection that is used to communicate with the
    # web service.
	@url = @info_values['url'].to_s + "/api/soap/mantisconnect.php"
    @client = Savon::Client.new do |wsdl|
      # The endpoint value represents the location of the actual SOAP web service
      wsdl.endpoint = @url
      # The namespace represents the unique identifier of the SOAP web service
      wsdl.namespace = "http://futureware.biz/mantisconnect"
    end
  end

  # This is a required method that is automatically called by the Kinetic Task
  # Engine.
  #
  # ==== Returns
  # A String representing the return variable results.
  def execute
    begin
      # Build and send a SOAP request for the 'mc_issue_add' method (namespaced with
      # 'wsdl') of the configured soap endpoint by setting the 'input' body parameter.
      #
      # If there was a problem executing the SOAP request, a Savon::SOAP::Fault
      # (indicating a Web Service exception was raised) or a Savon::HTTP::Error
      # (indicating there was a problem communicating with the server) will be
      # raised.
		
      response = @client.request 'wsdl:mc_issue_relationship_delete' do |soap_message|
        # Set the enumeration parameter to the one selected during Task node
        # configuration.  We need to prefix the parameter with a namespace since
        # it does not have a namespaced element to inherit from.
        soap_message.body = {
			'username' => @info_values['username'], 'password' => @info_values['password'], 'issue_id' => @parameters['issue_id'].to_i, 'relationship_id' => @parameters['relationship_id']
		}
      end
    # Rescue the error that is raised if we were unable to connect to the web
    # service server.
    rescue Errno::ECONNREFUSED
      # Re-raise a more intelligent error message (but maintain the original error backtrace).
      raise Errno::ECONNREFUSED, "Unable to connect to the web service endpoint: #{@url}", $!.backtrace
    # Rescue communication errors.
    rescue Savon::HTTP::Error
      # Re-raise a more intelligent error message (but maintain the original error type and backtrace).
      raise StandardError, "There was a problem calling the web service: #{$!.to_s}", $!.backtrace
    # Rescue exceptions raised by the web service
    rescue Savon::SOAP::Fault
      # Re-raise a more intelligent error message (but maintain the original error type and backtrace).
      raise StandardError, "There was a problem executing the web method: #{$!.to_s}", $!.backtrace
    end

    # In order to process the result, we will first convert the Savon::Response
    # object into a hash, then retrieve the desired value.
    res = response.to_hash[:mc_issue_relationship_delete_response][:return]

    # Build and return the results
    <<-RESULTS
    <results>
      <result name="Mantis_Issue_Relationship_Delete_Success">#{res}</result>
    </results>
    RESULTS
  end

  ##############################################################################
  # General handler utility functions
  ##############################################################################

  # This is a template method that is used to escape results values (returned in
  # execute) that would cause the XML to be invalid.  This method is not
  # necessary if values do not contain character that have special meaning in
  # XML (&, ", <, and >), however it is a good practice to use it for all return
  # variable results in case the value could include one of those characters in
  # the future.  This method can be copied and reused between handlers.
  def escape(string)
    # Globally replace characters based on the ESCAPE_CHARACTERS constant
    string.to_s.gsub(/[&"><]/) { |special| ESCAPE_CHARACTERS[special] } if string
  end
  # This is a ruby constant that is used by the escape method
  ESCAPE_CHARACTERS = {'&'=>'&amp;', '>'=>'&gt;', '<'=>'&lt;', '"' => '&quot;'}
end